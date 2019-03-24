module ActionComponent
  # Represents a component with a template, style and javascript file
  class Component
    def initialize(component_path)
      @component_path = component_path
    end

    def render
      renderer.render(path: @component_path)
    end

    private

    def renderer
      ActionComponent::Component::Renderer.new(lookup_context)
    end

    def lookup_context
      ActionView::LookupContext.new(
        [
          ActionComponent.configuration.components_path,
          Rails.root.join(ActionComponent.configuration.components_path)
        ]
      )
    end
  end
end
