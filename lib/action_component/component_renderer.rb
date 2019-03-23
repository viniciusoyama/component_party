module ActionComponent
  class ComponentRenderer
    def initialize(view_renderer = ActionView::Renderer.new(lookup_context))
      @view_renderer = view_renderer
    end

    def render(opts)
      @view_renderer.render(rendering_context, file: template_path_from_component_path(opts[:path]))
    end

    def rendering_context
      Class.new do
      end.new
    end

    def template_path_from_component_path(component_path, template_file_name: 'template')
      File.join(component_path, template_file_name).to_s
    end

    def lookup_context
      @lookup_context ||= ActionView::LookupContext.new(
        [
          ActionComponent.configuration.components_path,
          Rails.root.join(ActionComponent.configuration.components_path)
        ]
      )
    end
  end
end
