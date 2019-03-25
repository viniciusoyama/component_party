require 'rails/railtie'
require 'byebug'
class ViewComponent
  class Rails < Rails::Railtie
    initializer 'view_component' do
      config.assets.paths << ::Rails.root.join(ActionComponent.configuration.components_path)

      ::ActionView::Base.send(:include, ActionComponent::ImporterHelper)
    end
  end
end
