# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/AbcSize

module ComponentParty #:nodoc:
  # Renders a given component
  module ActionView
    module Renderer
      def render(context, options)
        if options.key?(:component)
          normalize_component_args!(options)
          ComponentParty::ActionView::ComponentRenderer.new(lookup_context, options[:component]).render(context, options)
        else
          super(context, options)
        end
      end
      # This method is part of the ActionController::Rendering module and only after
      # all the attributes passed to the #render maethod are normalized
      # An example of options argumento passed by Rails is
      # {
      #   :prefixes=>["devise/sessions", "devise", "application"],
      #   :template=>"new",
      #   :layout=> a Proc
      # }
      # def render_to_body(options = {})
      #   if options.key?(:component)
      #     component_path = get_path_for_component_render_options(options)
      #     render_component(path: component_path, view_model_data: options[:view_model_data], options: options)
      #   else
      #     super
      #   end
      # end

      def normalize_component_args!(options)
        if options[:component] == true
          options[:component] = Pathname.new(ComponentParty.configuration.component_folder_for_actions).join(options[:prefixes].first.to_s, options[:template]).to_s
        elsif options[:component].is_a?(String)
          options[:component] = get_full_component_path_from(options)
        else
          raise "Wrong value for 'component' key while calling render method. Argument class is #{options[:component].class}. Only String or true values are expected."
        end
      end

      private
      def get_full_component_path_from(options)
        if options[:component].starts_with?('./')
          raise "You cannot use a relative component importing outside a component's template." if options[:caller_component_path].blank?
          Pathname.new(options[:caller_component_path]).join(options[:component]).to_s
        else
          options[:component]
        end
      end

      # def render_component(path:, view_model_data:, options:)
      #   view_model_data ||= {}
      #   view_model_data = { c: self, controller: self }.merge(view_model_data)
      #
      #   ComponentParty::Component.new(
      #     path: path,
      #     view_model_data: view_model_data,
      #     lookup_context: render_component_lookup_context
      #   ).render(view_context, options)
      # end
      #
      # private
      #
      # def render_component_lookup_context
      #   view_paths.push(Rails.root.join(ComponentParty.configuration.components_path))
      #   ActionView::LookupContext.new(view_paths)
      # end
    end
  end
end

# rubocop:enable all
