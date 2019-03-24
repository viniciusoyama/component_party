module ActionComponent
  # Renders a given component
  class Component
    class Renderer < ActionView::Renderer
      class ComponentTemplateFileNotFound < StandardError; end
      
      attr_reader :view_model

      def initialize(lookup_context, view_model)
        @lookup_context = lookup_context
        @view_model = view_model
      end

      def render(component_path:)
        file_path = template_path_from_component_path(component_path)
        super(view_model, file: file_path)
      end

      def template_path_from_component_path(component_path, template_file_name: ActionComponent.configuration.template_file_name)
        File.join(component_path, template_file_name).to_s
      end

    end
  end
end
