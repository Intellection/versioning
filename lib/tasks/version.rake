namespace :version do
  desc "bump local major version"
  task :bump_major do
    version = Versioning::VersionFile.read_version
    version.bump_major
    Versioning::VersionFile.update(version)
  end

  desc "bump local minor version"
  task :bump_minor do
    version = Versioning::VersionFile.read_version
    version.bump_minor
    Versioning::VersionFile.update(version)
  end

  desc "bump local patch"
  task :bump_patch do
    version = Versioning::VersionFile.read_version
    version.bump_patch
    Versioning::VersionFile.update(version)
  end

  namespace :github do
    desc "bump local and github major versions"
    task :bump_major do
      update_version_and_push_changes(:bump_major)
    end

    desc "bump local and github minor versions"
    task :bump_minor do
      update_version_and_push_changes(:bump_minor)
    end

    desc "bump local and github patch versions"
    task :bump_patch do
      update_version_and_push_changes(:bump_patch)
    end

    def update_version_and_push_changes(method_name)
      raise "\e[31mYou must be on the master branch to bump a version, switch to master branch and try again!\e[0m" unless get_branch == 'master'
      puts "\e[92mEnter your version changes summary bellow:\e[0m"
      message = STDIN.gets.chomp
      raise ArgumentError, "Message can't be blank!" if message == nil || message == ''

      version = get_last_tag
      version.public_send(method_name)
      Versioning::VersionFile.update(version)
      git_client.commit_version_file
      git_client.create_tag(version, message)

      ping_channels(message, version)

      run_deployment
    end

    def ping_channels(changes, version)
      webhooks = AppConfig.webhooks
      if webhooks
        webhooks.each do |webhook|
          message = {
            color: "#000000",
            author_name: git_user,
            fields: [
              { title: 'Version', value: version.to_s, short: true },
              { title: 'App', value: app_name, short: true },
              { title: 'Changes', value: changes, short: false }
            ]
          }
          Versioning::Slackbot.new(app_name, webhook).send_message("#{git_user} has released a new version of #{app_name}!", message)
        end
      end
    end

    def app_name
      @app_name ||= Rails.application.class.parent_name
    end

    def git_user
      @user ||= `git config --global user.name`.strip rescue "Unknown user"
    end

    def run_deployment
      loop do
        puts 'Would you like to deploy the app to production?'
        print '[Y]es/ [N]o : '
        choice = STDIN.gets.chomp.upcase
        case choice
          when 'Y'
            deploy_app
            break
          when 'N'
            loop do
              puts "\e[31mIt is not advised to delay deploying the app! This can cause issues!\e[0m"
              puts 'Would you like to deploy NOW?'
              print '[Y]es/ [N]o : '
              choice = STDIN.gets.chomp.upcase
              case choice
                when 'Y'
                  deploy_app
                  break
                when 'N'
                  break
                else
                  puts 'Unknown command, please type either Y or N'
              end
            end
            break
          else
            puts 'Unknown command, please type either Y or N'
        end
      end
    end

    def deploy_app
      system 'cap production deploy'
    end

    def get_branch
      current_branch = `git rev-parse --abbrev-ref HEAD`
      current_branch.strip
    end

    def get_last_tag
      git_client.get_tags.last
    end

    def git_client
      @git_client ||= Versioning::Git.new
    end
  end

  desc "update local version with last remote version"
  task :update_from_remote do
    last_version = Versioning::Git.new.get_tags.last
    Versioning::VersionFile.update(last_version)
  end
end
