require 'component_party/importer_helper'
require 'component_party/view_model'
require 'component_party/action_view/renderer'
require 'component_party/action_view/component_renderer'

module ComponentParty
  # Configuration class for ComponentParty
  # @attr components_path [String] Components folder path (defaults to 'app/components')
  # @attr components_path [String] Component's template file name (defaults to 'template')
  class Configuration
    attr_accessor :components_path
    attr_accessor :template_file_name
    attr_accessor :view_model_file_name
    attr_accessor :component_folder_for_actions

    def initialize
      @components_path = 'app/components'
      @template_file_name = 'template'
      @view_model_file_name = 'view_model'
      @component_folder_for_actions = 'pages'
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require 'component_party/railtie'
