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
        else
          options[:component]
        end
      end
      # rubocop:enable all
    end
  end
end
