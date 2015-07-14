module Versioning
  class Version
    attr_reader :major_version, :minor_version, :patch

    def initialize(major_version, minor_version, patch)
      @major_version = major_version.to_i
      @minor_version = minor_version.to_i
      @patch = patch.to_i
    end

    def bump_major
      @major_version += 1
      @minor_version = 0
      @patch = 0
    end

    def bump_minor
      @minor_version += 1
      @patch = 0
    end

    def bump_patch
      @patch += 1
    end

    def to_s
      "#{major_version}.#{minor_version}.#{patch}"
    end

    def <=>(other)
      result = self.major_version <=> other.major_version
      if (result == 0)
        result = self.minor_version <=> other.minor_version
        if (result == 0)
          result = self.patch <=> other.patch
        end
      end
      result
    end

    def self.create_for_string(string)
      versions = string.split(".")
      self.new(versions[0], versions[1], versions[2])
    end
  end
end
