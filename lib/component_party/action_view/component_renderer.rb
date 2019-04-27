module ComponentParty
  # Renders a given component
  module ActionView
    class ComponentRenderer < ::ActionView::TemplateRenderer
      attr_reader :lookup_context
      attr_reader :component_path

      def initialize(lookup_context, component_path)
        @component_path = component_path
        super(lookup_context)
      end

      def render(context, options)
        options[:template] = template_path_from_component_path(options[:component])
        options[:locals] = { vm: create_view_model(context, options) }
        super(context, options)
      end

      def render_template(context, template, layout_name = nil, locals = nil) #:nodoc:
        super(context, decorate_template(template), layout_name, locals)
      end

      def decorate_template(template)
        ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator.new(template, component_path)
      end

      def create_view_model(context, options)
        view_model_data = options[:view_model_data] || {}
        view_model_data[:view] = context

        vm_class = find_vm_class(options)

        vm_class.new(view_model_data)
      end

      def find_vm_class(options)
        if options[:custom_view_model]
          if options[:custom_view_model] == true
            vm_file_path = Pathname.new(options[:component]).join(ComponentParty.configuration.view_model_file_name).to_s
            ActiveSupport::Inflector.camelize(vm_file_path).constantize
          else
            options[:custom_view_model]
          end
        else
          ComponentParty::ViewModel
        end
      end

      def template_path_from_component_path(component_path, template_file_name: ComponentParty.configuration.template_file_name)
        Pathname.new(component_path).join(template_file_name).to_s
      end
    end
  end
end
