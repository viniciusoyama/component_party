require 'rails_helper'

describe ComponentParty::ImporterHelper do
  let(:subject) do
    sub = Class.new do
      include ComponentParty::ImporterHelper
    end.new

    sub
  end

  describe '#import_component' do
    describe 'generated component method' do
      context 'path is absolute' do
        it "calls render with the absolute path" do
          expect(subject).to receive(:render).with(hash_including(component: 'my_path_to_header/folder'))

          subject.import_component 'Header', path: 'my_path_to_header/folder'

          subject.Header()
        end
      end

      context 'path is relative' do
        it 'Appends the parent component when there is a current_component_path' do
          subject.instance_variable_set('@current_component_path', 'pages/users/index')

          subject.import_component 'Test', path: './test'

          expect(subject).to receive(:render).with(hash_including(component: 'pages/users/index/test'))

          subject.Test()
        end

        it "raises an exception if i'm not inside a component" do
          expect {
            subject.import_component 'Test', path: './test'
          }.to raise_error("You cannot use a relative component importing outside a component's template.")
        end
      end

      context 'ViewModel customization' do
        it "sets custom_view_model to false if none is provided" do
            subject.import_component 'Test', path: 'test'

            expect(subject).to receive(:render).with(hash_including(custom_view_model: false))

            subject.Test()
        end

        it "passes the custom_view_model as option" do
          subject.import_component 'Test', path: 'test', custom_view_model: 'customvm'

          expect(subject).to receive(:render).with(hash_including(custom_view_model: 'customvm'))

          subject.Test()
        end
      end

      it "passes the view model data" do
        expect(subject).to receive(:render).with(hash_including(view_model_data: { data: 2 }))

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
