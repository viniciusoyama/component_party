# frozen_string_literal: true
require 'rails_helper'

describe 'Component wraps', type: :view do

  it 'wraps the component within a tag with the correct data attribute' do
    render template: 'testing/nested_components'

    expect(rendered).to have_css('div[class=green][data-component-path=\'parent\'] span[class=blue][data-component-path=\'parent-children\']')
  end

end
