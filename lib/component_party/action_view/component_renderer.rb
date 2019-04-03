module ComponentParty
  # Renders a given component
  module ActionView
    class ComponentRenderer < ::ActionView::TemplateRenderer
      attr_reader :lookup_context

      def initialize(lookup_context)
        lookup_context.view_paths.push(Rails.root.join(ComponentParty.configuration.components_path))
        super(lookup_context)
      end

      def render(context, options)
        options[:file] = template_path_from_component_path(options[:component])
        options[:locals] = { vm: create_view_model(options[:component], options[:view_model_data], context) }
        options[:locals][:current_component_path] = options[:current_component_path] if options[:current_component_path].present?
        super(context, options)
      end

      def render_template(template, layout_name = nil, locals = nil) #:nodoc:
        super(decorate_template(template), layout_name, locals)
      end

      def decorate_template(template)
        template
      end

      def create_view_model(_component_path, view_model_data, context)
        view_model_data ||= {}
        view_model_data[:view] = context

        # vm_class = find_custom_vm_class
        vm_class ||= ComponentParty::ViewModel

        vm_class.new(view_model_data)
      end

      def template_path_from_component_path(component_path, template_file_name: ComponentParty.configuration.template_file_name)
        Pathname.new(component_path).join(template_file_name).to_s
      end
    end
  end
end
