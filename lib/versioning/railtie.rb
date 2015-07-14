require 'versioning'
require 'rails'

module Versioning
  class Railtie < Rails::Railtie
    railtie_name :versioning

    rake_tasks do
      load "tasks/version.rake"
    end
  end
end
