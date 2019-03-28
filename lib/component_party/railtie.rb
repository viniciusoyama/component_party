require 'rails/railtie'

class ViewComponent
  class Rails < Rails::Railtie
    initializer 'view_component' do
      config.assets.paths << ::Rails.root.join(ComponentParty.configuration.components_path)

      ::ActionController::Base.send(:prepend, ComponentParty::Controller::Rendering)
      ::ActionView::Base.send(:include, ComponentParty::ImporterHelper)
    end
  end
end
