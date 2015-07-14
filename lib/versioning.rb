require "versioning/version"

module Versioning
end

require_relative "versioning/git"
require_relative "versioning/version"
require_relative "versioning/version_file"
require_relative "versioning/railtie" if defined?(Rails)
