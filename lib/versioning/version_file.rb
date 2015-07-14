module Versioning
  class VersionFile
    class << self
      def update(version)
        file = File.open(file_path, "w")
        file.write(version.to_s)
        file.close
      end

      def read_version
        version_string = File.read(file_path)
        Versioning::Version.create_for_string(version_string)
      end

      def file_path
        File.join(Rails.root, "config/version.txt")
      end
    end
  end
end
