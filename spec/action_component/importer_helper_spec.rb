require 'rails_helper'

describe ActionComponent::ImporterHelper do


  describe '#import_action_component' do
    let(:mock_component) { double() }

    let(:subject) do
      sub = Class.new do
        include ActionComponent::ImporterHelper
      end.new

      allow(sub).to receive(:create_component).and_return(mock_component)

      sub
    end

    before(:each) do
      allow(mock_component).to receive(:render)
    end

    describe 'generated component method' do
      it "creates a method with correct name" do
        subject.import_action_component 'Header', path: 'my_path_to_header/folder'

        expect(subject).to respond_to(:Header)
      end

      it "renders the component" do
        expect(mock_component).to receive(:render)

        subject.import_action_component 'Header', path: 'my_path_to_header/folder'

        subject.Header()
      end

      it "Passes the arguments" do
        expect(subject).to receive(:create_component).with('my_path_to_header/folder', { a: 2 })

        subject.import_action_component 'Header', path: 'my_path_to_header/folder'

        subject.Header(a: 2)
      end

      it 'raises if there is no path' do
        expect {
          subject.import_action_component 'Header'
        }.to raise_error('No path informed when importing component Header')
      end
    end
  end

  describe '#create_component' do
    let(:mock_view_renderer) { double() }

    let(:subject) do
      sub = Class.new do
        include ActionComponent::ImporterHelper
      end.new

      allow(sub).to receive(:view_renderer).and_return(mock_view_renderer)

      sub
    end

    it "returns an instace of ActionComponent::Component::Renderer" do
      expect(subject.create_component('my path', {})).to be_an_instance_of(ActionComponent::Component)
    end
  end
end
