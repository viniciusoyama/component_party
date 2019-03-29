# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/AbcSize

module ComponentParty #:nodoc:
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
          component_path = get_path_for_component_render_options(options)
          render_component(path: component_path, view_model_data: options[:view_model_data])
        else
          super
        end
      end

      private

      def get_path_for_component_render_options(options)
        if options[:component] == true
          Pathname.new(ComponentParty.configuration.component_folder_for_actions).join(options[:prefixes].first.to_s, options[:template]).to_s
        elsif options[:component].is_a?(String)
          options[:component]
        else
          raise "Wrong value for 'component' key while calling render method. Argument class is #{options[:component].class}. Only String or true values are expected."
        end
      end

      def render_component(path:, view_model_data:)
        view_model_data ||= {}
        view_model_data = { c: self, controller: self }.merge(view_model_data)
        ComponentParty::Component.new(
          component_path: path,
          view_model_data: view_model_data
        ).render
      end
    end
  end
end

# rubocop:enable all
