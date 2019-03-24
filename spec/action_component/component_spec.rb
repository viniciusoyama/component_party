require 'rails_helper'

describe ActionComponent::Component do
  subject {
    ActionComponent::Component.new('/user-list')
  }

  describe '#render' do
    it "utilizes the renderer" do
      mock_renderer = double()
      expect(subject).to receive(:renderer).and_return(mock_renderer)
      expect(mock_renderer).to receive(:render)

      subject.render()
    end
  end
end
