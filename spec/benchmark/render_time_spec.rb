# frozen_string_literal: true
require 'rails_helper'

describe 'Benchmart: Render time', type: :view do

  pending 'is at most 10% slower than the original render :file from rails' do
    render file: 'testing/performance'


    html = Nokogiri::HTML(rendered)

    normal_time = html.css('.render-time').text.to_f
    with_vm_time = html.css('.component-with-vm-time').text.to_f
    no_vm_time = html.css('.component-no-vm-time').text.to_f

    expect(normal_time*6 > with_vm_time).to eq(true)
    expect(normal_time*6 > no_vm_time).to eq(true)
  end

end
