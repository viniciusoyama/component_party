# frozen_string_literal: true
require 'rails_helper'

describe 'Component rendering from view', type: :view do

  it 'Allows multiple renderings per view' do
    render file: 'testing/vm_exposition'

    expect(rendered).to have_css('.parent > .vm-data', text: 'Viny')
    expect(rendered).to have_css('.child > .vm-data', text: '18 yo')
  end

  it "Works with custom VM" do
    render file: 'testing/custom_vm'

    expect(rendered).to have_css('.view-model .name', text: 'Viny')
    expect(rendered).to have_css('.view-model .hardcoded', text: 'Hardcoded Method')

  end
end
