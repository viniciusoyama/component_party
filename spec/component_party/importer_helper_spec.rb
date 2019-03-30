require 'rails_helper'

describe ComponentParty::ImporterHelper do
  let(:subject) do
    sub = Class.new do
      include ComponentParty::ImporterHelper

      def controller
      end

      def component
        OpenStruct.new(
          path: 'component/path',
          lookup_context: ActionView::LookupContext.new(['lookup/folder'])
        )
      end

    end.new

    sub
  end

  describe '#import_component' do
    let(:mock_component) { double() }

    before(:each) do
      allow(subject).to receive(:create_component).and_return(mock_component)
      allow(mock_component).to receive(:render)
    end

    describe 'generated component method' do
      it "creates a method with correct name" do
        subject.import_component 'Header', path: 'my_path_to_header/folder'

        expect(subject).to respond_to(:Header)
      end

      it "renders the component" do
        expect(mock_component).to receive(:render)

        subject.import_component 'Header', path: 'my_path_to_header/folder'

        subject.Header()
      end

      it "Passes the arguments" do
        expect(subject).to receive(:create_component).with('my_path_to_header/folder', { a: 2 })

        subject.import_component 'Header', path: 'my_path_to_header/folder'

        subject.Header(a: 2)
      end

      it 'raises if there is no path' do
        expect {
          subject.import_component 'Header'
        }.to raise_error('No path informed when importing component Header')
      end
    end
  end

  describe '#create_component' do
    before(:each) do
      allow(subject).to receive(:get_import_component_lookup_context).and_return("mock")
    end

    it "returns an instace of ComponentParty::Component::Renderer" do
      expect(subject.create_component('my path', {})).to be_an_instance_of(ComponentParty::Component)
    end

    it "passes the path normalized" do
      expect(ComponentParty::Component).to receive(:new).with(hash_including(path: 'my path'))
      subject.create_component('my path', { name: 'ze' })
    end

    it "passes the controller as VM data" do
      mock_controller = double
      allow(subject).to receive(:controller).and_return(mock_controller)
      expect(ComponentParty::Component).to receive(:new).with(hash_including(view_model_data: hash_including(name: 'ze', controller: mock_controller, c: mock_controller)))
      subject.create_component('my path', { name: 'ze' })
    end
  end

  describe '#get_import_component_lookup_context_for' do

    context 'when path is absolute' do
      it "doesn't returns a lookup_context" do
        expect(subject.get_import_component_lookup_context_for('/test')).to be_nil
        expect(subject.get_import_component_lookup_context_for('test')).to be_nil
      end
    end

    context 'when path is relative' do

      it 'Appends the parent component path with its lookup_context base path' do
        lookup = subject.get_import_component_lookup_context_for('./test')
        expect(lookup.view_paths.first.to_s).to end_with('lookup/folder/component/path')
      end

      it "raises an exception if i'm not inside a component" do
        allow(subject).to receive(:component).and_raise(NameError.new('error'))

        expect {
          subject.get_import_component_lookup_context_for('./my path')
        }.to raise_error("You cannot use a relative component importing outside a component's template.")
      end
    end

  end

end
