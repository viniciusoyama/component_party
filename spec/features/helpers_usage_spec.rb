# frozen_string_literal: true
require 'rails_helper'

describe 'Helpers methods', type: :view do
  it 'Exposes rails view helpers inside a componet' do
    render file: 'testing/helpers'

    expect(rendered).to have_css('.parent > .date', text: '2019-01-03')
    expect(rendered).to have_css('.parent > .translation', text: 'Hello world')
  end

  it 'Exposes url helpers inside a componet' do
    render file: 'testing/helpers'

    expect(rendered).to have_css('.parent > .routes', text: '/users')
  end

  it 'Exposes helpers inside children componet' do
    render file: 'testing/helpers'

    expect(rendered).to have_css('.child > .date', text: '2019-01-03')
    expect(rendered).to have_css('.child > .routes', text: '/users')
    expect(rendered).to have_css('.child > .translation', text: 'Hello world')
  end
end
