require 'rails_helper'

describe ActionComponent::ComponentRenderer do
  let(:mock_action_view_renderer) { double() }

  let(:subject) do
    described_class.new(mock_action_view_renderer)
  end

  describe '#render' do
    it "calls render on action_view_renderer" do
      mock_context = double()

      expect(mock_action_view_renderer).to receive(:render).with(mock_context, file: 'my-path')
      allow(subject).to receive(:rendering_context).and_return(mock_context)

      subject.render(path: 'my-path')
    end
  end
end
