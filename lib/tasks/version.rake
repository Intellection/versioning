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
    # version.bump_patch
    # Versioning::VersionFile.update(version)
    puts "..............."
    puts "executed bump local patch"
    puts version
    puts "..............."
  end

  namespace :github do
    desc "bump local and github major versions"
    task :bump_major do
      git_client = Versioning::Git.new
      version = git_client.get_tags.last
      version.bump_major
      Versioning::VersionFile.update(version)
      git_client.commit_version_file
      git_client.create_tag(version)
    end

    desc "bump local and github minor versions"
    task :bump_minor do
      git_client = Versioning::Git.new
      version = git_client.get_tags.last
      version.bump_minor
      Versioning::VersionFile.update(version)
      git_client.commit_version_file
      git_client.create_tag(version)
    end

    desc "bump local and github patch versions"
    task :bump_patch do
      git_client = Versioning::Git.new
      version = git_client.get_tags.last
      version.bump_patch
      Versioning::VersionFile.update(version)
      git_client.commit_version_file
      git_client.create_tag(version)
    end
  end

  desc "update localversion with last remote version"
  task :update_from_remote do
    last_version = Versioning::Git.new.get_tags.last
    Versioning::VersionFile.update(last_version)
  end
end
