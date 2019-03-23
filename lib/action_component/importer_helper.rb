module ActionComponent
  module ImporterHelper
    def import_action_component(local_component_name, opts = {})
      raise "No path informed when importing component #{local_component_name}" if opts[:path].blank?
      define_singleton_method(local_component_name) do
        component_renderer.render(opts)
      end
    end
  end
end
