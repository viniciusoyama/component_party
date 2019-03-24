module ActionComponent
  # Represents a component with a template, style and javascript file
  class Component
    def initialize(component_path, lookup_context = nil)
      @component_path = component_path.to_s.gsub(/^\//, '')
      @lookup_context = lookup_context
    end

    def render
      renderer.render(component_path: @component_path)
    end

    def renderer
      ActionComponent::Component::Renderer.new(lookup_context, view_model)
    end

    def lookup_context
      @lookup_context ||= ActionView::LookupContext.new(
        [
          full_component_path
        ]
      )
    end

    def view_model
      begin
        vm_file_path = Pathname.new(@component_path).join(ActionComponent.configuration.view_model_file_name)
        ActiveSupport::Inflector.camelize(vm_file_path).constantize.new
      rescue NameError => ex
        ActionComponent::Component::ViewModel.new
      end
    end

    def vm_class
      vm_file_path = Pathname.new(@component_path).join(ActionComponent.configuration.view_model_file_name)
      ActiveSupport::Inflector.camelize(vm_file_path)
      vm_file_path.gsub(".rb", '').split('/').map(&:capitalize).join('::').constantize.new
    end

    def full_component_path
      Rails.root.join(ActionComponent.configuration.components_path)
    end
  end
end
