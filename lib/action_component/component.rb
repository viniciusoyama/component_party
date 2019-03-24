module ActionComponent
  # Represents a component with a template, style and javascript file
  class Component
    class InvalidVMError < StandardError; end;
    class << self
      def helper_object
        @helper_object = Class.new(ActionView::Base) do
          include ::Rails.application.routes.url_helpers
          include ::Rails.application.routes.mounted_helpers
        end.new
      end

      def helper_vm_params
        {
          h: helper_object,
          helper: helper_object
        }
      end
    end

    attr_reader :view_model_data
    def initialize(component_path: component_path, lookup_context: nil, view_model_data: {})
      @component_path = component_path.to_s.gsub(%r{^/}, '')
      @lookup_context = lookup_context
      @view_model_data = view_model_data
    end

    def render
      renderer.render(component_path: @component_path)
    end

    def renderer
      ActionComponent::Component::Renderer.new(lookup_context, create_view_model)
    end

    def lookup_context
      @lookup_context ||= ActionView::LookupContext.new(
        [
          full_component_path
        ]
      )
    end

    def create_view_model
      vm_class = ActionComponent::Component::ViewModel

      begin
        vm_file_path = Pathname.new(@component_path).join(ActionComponent.configuration.view_model_file_name)
        vm_class = ActiveSupport::Inflector.camelize(vm_file_path).constantize

        unless vm_class.ancestors.include?(ActionComponent::Component::ViewModel)
          error_msg = "#{vm_class} cannot be used as a ViewModel. Make sure that it inherits from ActionComponent::Component::ViewModel."
          raise ActionComponent::Component::InvalidVMError, error_msg
        end
      rescue NameError
        vm_class = ActionComponent::Component::ViewModel
      end


      vm_class.new(**view_model_data.merge(view_model_default_data))
    end

    def view_model_default_data
      # lookup_context is necessary for when there is an exception in our template
      # this is used in order to better describe the error stack
      self.class.helper_vm_params.merge({lookup_context: lookup_context})
    end
    def full_component_path
      Rails.root.join(ActionComponent.configuration.components_path)
    end
  end
end
