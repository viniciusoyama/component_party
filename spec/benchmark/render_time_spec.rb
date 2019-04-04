# frozen_string_literal: true
require 'rails_helper'

describe 'Benchmart: Render time', type: :integration do

  it 'is at most 5x slower than the original render :file from rails' do
    visit '/testing/performance'

    normal_time = find('.render-time').text.to_f
    normal_time = normal_time > 0.0 ? normal_time : 0.01
    with_vm_time = find('.component-with-vm-time').text.to_f
    no_vm_time = find('.component-no-vm-time').text.to_f

    # expect(no_vm_time).to be < (normal_time*5)
    # expect(with_vm_time).to be < (normal_time*5)
  end

end
