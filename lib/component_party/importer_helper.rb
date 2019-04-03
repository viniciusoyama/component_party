module ComponentParty
  # Exposes component rendering methods to Rails views

  module ImporterHelper
    # Description of #import_component
    #
    # @param local_component_name [String] Local's component name (in the view scope)
    # @param opts [Hash] default: {} Options.
    # @example
    def import_component(local_component_name, opts = {})
      raise "No path informed when importing component #{local_component_name}" if opts[:path].blank?

      current_component_path = instance_variable_get('@current_component_path')
      define_singleton_method(local_component_name) do |**args|
        render(component: opts[:path], view_model_data: args, caller_component_path: current_component_path)
      end
    end
  end
end
