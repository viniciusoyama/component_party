module ComponentParty #:nodoc:
  # Renders a given component
  module ActionView
    module Renderer
      method_to_override = if Rails::VERSION::STRING.start_with?('6')
                             'render_to_object'
                           else
                             'render'
                           end

      define_method(method_to_override) do |context, options|
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
      def normalize_component_path!(_context, options)
        if options[:component] == true
          options[:component] = Pathname.new(options[:prefixes].first.to_s).join(options[:template]).to_s
          options[:prefixes] = [ComponentParty.configuration.component_folder_for_actions]
        else
          options[:component]
          options[:prefixes] = []
        end
      end
    end
  end
end
