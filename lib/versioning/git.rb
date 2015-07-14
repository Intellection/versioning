module Versioning
  class Git
    def get_tags
      update_tags
      tags = execute_git_command("tag")
      tags.split("\n").map do |version_string|
        Versioning::Version.create_for_string(version_string)
      end.sort
    end

    def create_tag(version)
      update_tags
      execute_git_command("tag #{version.to_s}")
      execute_git_command("push --tags")
    end

    private
    def update_tags
      execute_git_command("fetch --tags")
    end

    def execute_git_command(command)
      command = IO.popen("git #{command}")
      begin
        command.read
      rescue StandardError => e
        puts "ERROR WHILE EXECUTING COMMAND: '#{e.message}'"
      ensure
        command.close
      end
    end
  end

end
