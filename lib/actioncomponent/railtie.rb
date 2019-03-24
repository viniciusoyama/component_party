require 'rails/railtie'

class ViewComponent
  class Rails < Rails::Railtie
    config.view_component = ActiveSupport::OrderedOptions.new

    initializer 'view_component' do
      ::ActionView::Base.send(:include, ActionComponent::ImporterHelper)
    end
  end
end
