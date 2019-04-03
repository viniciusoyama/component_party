module ComponentParty
  # Renders a given component
  module ActionView
    class ComponentRenderer < ::ActionView::TemplateRenderer
      class ComponentTemplateFileNotFound < StandardError; end

      # Decorates the template renderer chosen to render
      # the current view/template/file.
      # It overrides the render method in order to ignore the default's
      # view_context_class created by the controller and uses the view model
      # as the context of the rendering proccess
      class ComponentTemplateDecorator < SimpleDelegator
        attr_reader :view_model
        attr_reader :component_path

        def initialize(lookup_context, component_path)
          super(lookup_context)
          @component_path = component_path
        end

        def render(_original_rails_context, options = {}, &block)
          rendered = __getobj__.render(view_model, options, &block)
          rendered = apply_html_namespacing(rendered.to_s)
          ActionView::OutputBuffer.new(rendered)
        end

        def apply_html_namespacing(raw_html)
          component_id = component_path.gsub(%r{^/}, '').tr('/', '-')
          "<div class='component' data-component-path='#{component_id}'>" + raw_html + '</div>'.html_safe
        end
      end

      attr_reader :view_model
      attr_reader :component_path

      def initialize(component)
        @lookup_context = component.lookup_context
        @view_model = component.view_model
        @component_path = component.path
      end

      def render(view_context, options = {})
        options[:file] = template_path_from_component_path(component_path)

        super(view_context, options)
      end

      def render_template(template, layout_name = nil, locals = nil)
        super(ComponentTemplateDecorator.new(template, view_model, component_path), layout_name, locals)
      end

      def template_path_from_component_path(component_path, template_file_name: ComponentParty.configuration.template_file_name)
        Pathname.new(component_path).join(template_file_name).to_s
      end
    end
  end
end
