require 'rails/railtie'

class ViewComponent
  class Rails < Rails::Railtie
    initializer 'view_component' do
      config.assets.paths << ::Rails.root.join(ActionComponent.configuration.components_path)

      ::ActionController::Base.send(:prepend, ActionComponent::Controller::Rendering)
      ::ActionView::Base.send(:include, ActionComponent::ImporterHelper)
    end
  end
end
