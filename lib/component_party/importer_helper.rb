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

      define_singleton_method(local_component_name) do |**args|
        create_component(opts[:path], args).render
      end
    end

    def create_component(component_path, view_model_data)
      ComponentParty::Component.new(
        path: component_path,
        lookup_context: get_import_component_lookup_context_for(component_path),
        view_model_data: view_model_data.merge(c: controller, controller: controller)
      )
    end

    def get_import_component_lookup_context_for(path)
      if path.starts_with?('./')
        new_search_path = Pathname.new(component.lookup_context.view_paths[0].to_s).join(component.path)
        ActionView::LookupContext.new([new_search_path.to_s])
      end
    rescue NameError
      raise "You cannot use a relative component importing outside a component's template."
    end
  end
end
