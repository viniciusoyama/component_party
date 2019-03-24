require 'rails_helper'

describe ActionComponent::Component do
  subject {
    ActionComponent::Component.new('/user_list')
  }

  describe '#render' do
    it "utilizes the renderer" do
      mock_renderer = double()
      expect(subject).to receive(:renderer).and_return(mock_renderer)
      expect(mock_renderer).to receive(:render)

      subject.render()
    end
  end

  describe '#view_model' do
    it "returns a default instance if custom vm file doesn't exists" do
      subject = ActionComponent::Component.new('/component_without_vm')
      expect(subject.view_model).to be_an_instance_of(ActionComponent::Component::ViewModel)
    end

    it "searches for a constant with the vm path" do
      lookup_context = ActionView::LookupContext.new(
        [fixture_path('/components')]
      )

      subject = ActionComponent::Component.new('/with_vm', lookup_context)

      expect(subject.view_model).to be_an_instance_of(WithVm::ViewModel )
    end
  end

  describe '#lookup_context' do
    it "setups a LookupContext according to the gem configuration" do
      allow(ActionComponent.configuration).to receive(:components_path).and_return('mockpath')
      expect(subject.lookup_context.view_paths.first.to_s).to match(/mockpath$/)
    end
  end
end
