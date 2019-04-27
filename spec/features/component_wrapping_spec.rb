# frozen_string_literal: true
require 'rails_helper'

describe 'Component wraps', type: :view do

  it 'wraps the component within a tag with the correct data attribute' do
    render template: 'testing/nested_components'

    expect(rendered).to have_css('div[data-component-path=\'parent\'] div[data-component-path=\'parent-children\']')
    expect(rendered).to have_css('div[data-component-path=\'parent\']')
  end

end
