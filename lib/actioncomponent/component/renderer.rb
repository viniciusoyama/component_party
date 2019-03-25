module ActionComponent
  # Renders a given component
  class Component
    class Renderer < ActionView::TemplateRenderer
      class ComponentTemplateFileNotFound < StandardError; end

      attr_reader :view_model

      def initialize(lookup_context, view_model)
        @lookup_context = lookup_context
        @view_model = view_model
      end

      def render(component_path:)
        file_path = template_path_from_component_path(component_path)
        rendered = super(view_model, file: file_path)
        rendered = apply_html_namespacing(rendered, component_path)
        ActionView::OutputBuffer.new(rendered)
      end

      def template_path_from_component_path(component_path, template_file_name: ActionComponent.configuration.template_file_name)
        File.join(component_path, template_file_name).to_s
      end

      def apply_html_namespacing(raw_html, component_path)
        component_id = component_path.gsub(/^\//, '').gsub("/", '-')
        "<div class='action-component' data-action-component-id='#{component_id}'>" + raw_html + "</div>".html_safe
      end
    end
  end
end