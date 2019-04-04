require 'rails/railtie'

class ViewComponent
  class Rails < Rails::Railtie
    initializer 'view_component' do
      config.assets.paths << ::Rails.root.join(ComponentParty.configuration.components_path)

      ActiveSupport.on_load(:action_controller) do
        prepend_view_path(::Rails.root.join(ComponentParty.configuration.components_path)) if respond_to?(:prepend_view_path)
      end

      ::ActionView::Renderer.send(:prepend, ComponentParty::ActionView::Renderer)
      ::ActionView::Base.send(:include, ComponentParty::ImporterHelper)
    end
  end
end
