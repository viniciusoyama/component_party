require 'rails_helper'

describe ComponentParty::ImporterHelper do
  let(:subject) do
    sub = Class.new do
      include ComponentParty::ImporterHelper

      def current_component_path
        'current/path'
      end

    end.new

    sub
  end

  describe '#import_component' do
    describe 'generated component method' do
      it "calls render component" do
        expect(subject).to receive(:render).with(hash_including(component: 'my_path_to_header/folder'))

        subject.import_component 'Header', path: 'my_path_to_header/folder'

        subject.Header()
      end

      it "passes the view model data" do
        expect(subject).to receive(:render).with(hash_including(view_model_data: { data: 2 }))

        subject.import_component 'Header', path: 'my_path_to_header/folder'

        subject.Header(data: 2)
      end

      it "passes the current component path" do
        expect(subject).to receive(:current_component_path).and_return('current/path')
        expect(subject).to receive(:render).with(hash_including(current_component_path: 'current/path'))

        subject.import_component 'Header', path: 'my_path_to_header/folder'

        subject.Header(data: 2)
      end

    end

    it 'raises if there is no path' do
      expect {
        subject.import_component 'Header'
      }.to raise_error('No path informed when importing component Header')
    end
  end


end
