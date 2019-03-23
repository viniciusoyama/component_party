# frozen_string_literal: true
require 'rails_helper'

describe 'Component rendering from another component', type: :view do

  it 'Allows a compoent to be rendered inside another component' do
    render file: 'testing/nested_components'

    expect(rendered).to have_css('h1', text: 'Parent')
    expect(rendered).to have_css('h1', text: 'Children', count: 2)
  end
end
