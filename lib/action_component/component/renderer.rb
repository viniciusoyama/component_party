module ActionComponent
  # Renders a given component
  class Component
    class Renderer < ActionView::Renderer
      class ComponentTemplateFileNotFound < StandardError; end

      def initialize(lookup_context = nil)
        @lookup_context = lookup_context || ActionView::LookupContext.new(
          [
            ActionComponent.configuration.components_path,
            Rails.root.join(ActionComponent.configuration.components_path)
          ]
        )
      end

      def render(opts)
        file_path = template_path_from_component_path(opts[:path])
        super(view_context_class, file: file_path)
      end

      def view_context_class
        Class.new(ActionView::Base) do
          include ::Rails.application.routes.url_helpers
          include ::Rails.application.routes.mounted_helpers

          def lol
            "a"
          end
        end.new(lookup_context, {}, nil)
      end

      def template_path_from_component_path(component_path, template_file_name: ActionComponent.configuration.template_file_name)
        File.join(component_path, template_file_name).to_s
      end
    end
  end
end
