require 'rails_helper'

describe ComponentParty::ViewModel do
  it "generates a method for each argument" do
    vm = described_class.new(argument1: 'test1', argument2: 'test2')
    expect(vm.argument1).to eq('test1')
    expect(vm.argument2).to eq('test2')
  end
end
