# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

module ActionComponent #:nodoc:
  # Renders a given component
  module Controller
    module Rendering
      # This method is part of the ActionController::Rendering module and only after
      # all the attributes passed to the #render maethod are normalized
      # An example of options argumento passed by Rails is
      # {
      #   :prefixes=>["devise/sessions", "devise", "application"],
      #   :template=>"new",
      #   :layout=> a Proc
      # }
      def render_to_body(options = {})
        if options.key?(:component)
          component_path = if options[:component] == true
                             Pathname.new(ActionComponent.configuration.component_folder_for_actions).join(options[:prefixes].first.to_s, options[:template]).to_s
                           elsif options[:component].is_a?(String)
                             options[:component]
                           else
                             raise "Wrong value for 'component' key while calling render method. Argument class is #{options[:component].class}. Only String or true values are expected."
                           end
          render_component(path: component_path, view_model_data: options[:view_model_data])
        else
          super
        end
      end

      private

      def render_component(path:, view_model_data: )
        view_model_data ||= {}
        view_model_data = { c: self, controller: self }.merge(view_model_data)
        ActionComponent::Component.new(
          component_path: path,
          view_model_data: view_model_data
        ).render
      end
    end
  end
end

# rubocop:enable all
