require 'action_component/importer_helper'
require 'action_component/component'
require 'action_component/component/renderer'
require 'action_component/railtie'

module ActionComponent
  # Configuration class for ActionComponent
  # @attr components_path [String] Components folder path (defaults to 'app/components')
  # @attr components_path [String] Component's template file name (defaults to 'template')
  class Configuration
    attr_accessor :components_path
    attr_accessor :template_file_name

    def initialize
      @components_path = 'app/components'
      @template_file_name = 'template'
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
