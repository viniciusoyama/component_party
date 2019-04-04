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

      component_to_render_path = get_full_component_path(opts[:path])

      define_singleton_method(local_component_name) do |**args|
        render(component: component_to_render_path, view_model_data: args)
      end
    end

    private
    def get_full_component_path(path)
      if path.starts_with?('./')
        current_component_path = instance_variable_get('@current_component_path')

        raise "You cannot use a relative component importing outside a component's template." if current_component_path.blank?

        Pathname.new(current_component_path).join(path).to_s
      else
        path
      end
    end
  end
end
