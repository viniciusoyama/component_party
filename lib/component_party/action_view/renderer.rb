module ComponentParty #:nodoc:
  # Renders a given component
  module ActionView
    module Renderer
      def render(context, options)
        if options.key?(:component)
          normalize_data_for_component_rendering!(context, options)
          ComponentParty::ActionView::ComponentRenderer.new(lookup_context, options[:component]).render(context, options)
        else
          super(context, options)
        end
      end

      def normalize_data_for_component_rendering!(context, options)
        normalize_component_path!(context, options)
        context.instance_variable_set('@current_component_path', options[:component])
      end

      # An example of options argumento passed by Rails are
      # {
      #   :prefixes=>["devise/sessions", "devise", "application"],
      #   :template=>"new",
      #   :layout=> a Proc
      # }
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/LineLength
      def normalize_component_path!(context, options)
        if options[:component] == true
          options[:component] = Pathname.new(ComponentParty.configuration.component_folder_for_actions).join(options[:prefixes].first.to_s, options[:template]).to_s
        elsif options[:component].is_a?(String)
          options[:component] = get_full_component_path(context, options)
        else
          raise "Wrong value for 'component' key while calling render method. Argument class is #{options[:component].class}. Only String or true values are expected."
        end
      end
      # rubocop:enable all

      private

      def get_full_component_path(_context, options)
        if options[:component].starts_with?('./')
          raise "You cannot use a relative component importing outside a component's template." if options[:caller_component_path].blank?

          Pathname.new(options[:caller_component_path]).join(options[:component]).to_s
        else
          options[:component]
        end
      end
    end
  end
end
