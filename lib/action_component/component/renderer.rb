module ActionComponent
  # Renders a given component
  class Component
    class Renderer < ActionView::Renderer
      class ComponentTemplateFileNotFound < StandardError; end
      class ViewContext
        include ActionComponent::ImporterHelper

        def initialize(lookup_context, helper_object)
          @lookup_context = lookup_context
          @helper_object = helper_object
        end

        def helper
          @helper_object
        end

        alias h helper
      end

      def initialize(lookup_context)
        @lookup_context = lookup_context
      end

      def render(component_path:)
        file_path = template_path_from_component_path(component_path)
        super(view_context, file: file_path)
      end

      def view_context
        ViewContext.new(lookup_context, helper_object)
      end

      def template_path_from_component_path(component_path, template_file_name: ActionComponent.configuration.template_file_name)
        File.join(component_path, template_file_name).to_s
      end

      private

      def helper_object
        @helper_object = Class.new(ActionView::Base) do
          include ::Rails.application.routes.url_helpers
          include ::Rails.application.routes.mounted_helpers
        end.new
      end
    end
  end
end
