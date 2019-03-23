require 'rails_helper'

describe ActionComponent::ImporterHelper do
  let(:mock_component_renderer) do
    Class.new
  end

  let(:subject) do
    sub = Class.new do
      include ActionComponent::ImporterHelper
    end.new

    allow(sub).to receive(:component_renderer).and_return(mock_component_renderer)

    sub
  end

  describe '#import_action_component' do
    it "generates a new method with the name that was given" do
      subject.import_action_component 'Header', path: 'my_path_to_header/folder'

      expect(subject).to respond_to(:Header)
    end

    specify "The new method calls ActionComponent::Rendered" do
      expect(mock_component_renderer).to receive(:render).with(path: 'my_path_to_header/folder')

      subject.import_action_component 'Header', path: 'my_path_to_header/folder'

      subject.Header()
    end

    it 'raises if there is no path' do
      expect {
        subject.import_action_component 'Header'
      }.to raise_error('No path informed when importing component Header')
    end
  end
end
