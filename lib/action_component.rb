require 'action_component/importer_helper'
require 'action_component/component_renderer'
require 'action_component/railtie'

module ActionComponent
  class Configuration
    attr_accessor :components_path

    def initialize
      @components_path = 'app/components'
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
