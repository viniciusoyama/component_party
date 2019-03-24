module ActionComponent
  # Renders a given component
  class ComponentRenderer
    class ComponentTemplateFileNotFound < StandardError; end

    def initialize(view_renderer = ActionView::Renderer.new(lookup_context))
      @view_renderer = view_renderer
    end

    def render(opts)
      file_path = template_path_from_component_path(opts[:path])

      @view_renderer.render(rendering_context, file: file_path)
    end

    def rendering_context
      Class.new(ActionView::Base) do
        include ::Rails.application.routes.url_helpers
        include ::Rails.application.routes.mounted_helpers
      end.new(@view_renderer, {}, nil)
    end

    def template_path_from_component_path(component_path, template_file_name: ActionComponent.configuration.template_file_name)
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
