# frozen_string_literal: true
require 'rails_helper'

describe 'Controller Component Rendering', type: :integration do

  it 'Allows default rendering according to the action name' do
    visit '/testing/default_component'
    expect(page).to have_content('default component for action')
    expect(page).to have_content('custom vm data')
  end

  it "Renders the layout by default" do
    visit '/testing/default_component'
    expect(page).to have_content('I\'m application layout.')
  end

  it "allows to cancel the layout rendering" do
    visit '/testing/default_component?cancel_layout=true'
    expect(page).to have_content('default component for action')
    expect(page).to have_content('custom vm data')
    expect(page).to_not have_content('I\'m application layout.')
  end

  it 'Allows rendering with custom component' do
    visit '/testing/custom_component'

    expect(page).to have_content('custom component for action')
    expect(page).to have_content('Customizado custom vm data')
  end
end
