# frozen_string_literal: true
require 'rails_helper'

describe 'Controller Component Rendering', type: :integration do

  it 'Allows default rendering according to the action name' do
    visit '/testing/default_component'
    expect(page).to have_content('default component for action')
    expect(page).to have_content('custom vm data')
  end


  it 'Allows default rendering according to the action name' do
    visit '/testing/custom_component'
    expect(page).to have_content('custom component for action')
    expect(page).to have_content('Customizado custom vm data')
  end
end
