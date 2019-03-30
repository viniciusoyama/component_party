module ComponentParty
  # Renders a given component
  class Component
    class Renderer < ActionView::TemplateRenderer
      class ComponentTemplateFileNotFound < StandardError; end

      attr_reader :view_model
      attr_reader :component_path

      def initialize(component)
        @lookup_context = component.lookup_context
        @view_model = component.view_model
        @component_path = component.component_path
      end

      def render
        file_path = template_path_from_component_path(component_path)
        rendered = super(view_model, file: file_path)
        rendered = apply_html_namespacing(rendered, component_path)
        ActionView::OutputBuffer.new(rendered)
      end

      def template_path_from_component_path(component_path, template_file_name: ComponentParty.configuration.template_file_name)
        File.join(component_path, template_file_name).to_s
      end

      def apply_html_namespacing(raw_html, component_path)
        component_id = component_path.gsub(%r{^/}, '').tr('/', '-')
        "<div class='component' data-component-path='#{component_id}'>" + raw_html + '</div>'.html_safe
      end
    end
  end
end
