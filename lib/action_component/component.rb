module ActionComponent
  # Represents a component with a template, style and javascript file
  class Component
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

    def initialize(component_path, lookup_context = nil)
      @component_path = component_path.to_s.gsub(%r{^/}, '')
      @lookup_context = lookup_context
    end

    def render(**view_model_data)
      renderer(view_model_data).render(component_path: @component_path)
    end

    def renderer(view_model_data)
      ActionComponent::Component::Renderer.new(lookup_context, create_view_model(view_model_data))
    end

    def lookup_context
      @lookup_context ||= ActionView::LookupContext.new(
        [
          full_component_path
        ]
      )
    end

    def create_view_model(**view_model_data)
      vm_class = ActionComponent::Component::ViewModel

      begin
        vm_file_path = Pathname.new(@component_path).join(ActionComponent.configuration.view_model_file_name)
        vm_class = ActiveSupport::Inflector.camelize(vm_file_path).constantize
      rescue NameError
        vm_class = ActionComponent::Component::ViewModel
      end

      vm_class.new(**view_model_data.merge(self.class.helper_vm_params))
    end

    def vm_class
      vm_file_path = Pathname.new(@component_path).join(ActionComponent.configuration.view_model_file_name)
      ActiveSupport::Inflector.camelize(vm_file_path)
      vm_file_path.gsub('.rb', '').split('/').map(&:capitalize).join('::').constantize.new
    end

    def full_component_path
      Rails.root.join(ActionComponent.configuration.components_path)
    end
  end
end
