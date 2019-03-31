require 'rails_helper'

describe ComponentParty::Component do
  before(:each) do
    allow(ComponentParty::Component).to receive(:helper_vm_params).and_return({})
  end

  def create_component(path: , view_model_data: {})
    ComponentParty::Component.new(path: path, view_model_data: view_model_data)
  end

  subject {
    create_component(path: '/user_list')
  }

  describe '#render' do
    it "calls renderer with default arguments" do
      mock_renderer = double()
      expect(subject).to receive(:renderer).and_return(mock_renderer)
      expect(mock_renderer).to receive(:render).with(subject.view_model, {})
      subject.render()
    end

    it "fowards the rendering options" do
      mock_renderer = double()
      expect(subject).to receive(:renderer).and_return(mock_renderer)

      mock_vm = double()

      expect(mock_renderer).to receive(:render).with(mock_vm, layout: 'fowarded')

      subject.render(mock_vm, layout: 'fowarded')
    end
  end

  describe '#renderer' do
    it "setups a renderer" do
      expect(subject.renderer).to be_an_instance_of(ComponentParty::Component::Renderer)
    end
  end

  describe 'path normalization' do
    context 'when path is absolute' do
      it 'removes the first /' do
        component = create_component(path: 'user_list')
        expect(component.path).to eq('user_list')
        component = create_component(path: '/user_list')
        expect(component.path).to eq('user_list')
      end
    end


    context 'when path is relative' do
      it 'removes the first ./' do
        component = create_component(path: './user_list')
        expect(component.path).to eq('user_list')
      end
    end
  end

  describe '#view_model' do
    it 'raises an error if VM does not inherits from ComponentParty::Component::ViewModel' do
      subject = create_component(path: '/invalid_vm')

      expect {
        subject.view_model()
      }.to raise_error(ComponentParty::Component::InvalidVMError, 'InvalidVm::ViewModel cannot be used as a ViewModel. Make sure that it inherits from ComponentParty::Component::ViewModel.')
    end

    it "returns a default instance if custom vm file doesn't exists" do
      subject = create_component(path: '/component_without_vm')
      expect(subject.view_model()).to be_an_instance_of(ComponentParty::Component::ViewModel)
    end

    it "merges vm with default data" do
      subject = create_component(path: '/component_without_vm')
      allow(subject).to receive(:view_model_default_data).and_return({ aditional: 'more'} )
      expect(subject.view_model.aditional).to eq('more')
    end

    it "searches for a constant with the vm path" do
      subject = create_component(path: '/with_vm')

      expect(subject.view_model()).to be_an_instance_of(WithVm::ViewModel)
    end

    it 'passes the data to the view model' do
      expect(ComponentParty::Component::ViewModel).to receive(:new).with(hash_including(number: 8, word: 'hi')).and_call_original
      subject = create_component(path: '/component_without_vm', view_model_data: { number: 8, word: 'hi' })
      vm = subject.view_model()
    end

    it 'passes helpers to the VM' do
      subject = create_component(path: '/component_without_vm')
      mock_helpers = double()
      expect(ComponentParty::Component).to receive(:helper_vm_params).and_return({
        h: mock_helpers
      })
      vm = subject.view_model()
      expect(vm.h).to be(mock_helpers)
    end
  end

  describe '#view_model_default_data' do
    it 'adds helper methods' do
      subject = create_component(path: '/component_without_vm')
      expect(subject.class).to receive(:helper_vm_params).and_return({ helper: 'existing' })
      expect(subject.view_model_default_data[:helper]).to eq('existing')
    end

    it 'adds lookup_context' do
      subject = create_component(path: '/component_without_vm')
      expect(subject).to receive(:lookup_context).and_return('existing' )
      expect(subject.view_model_default_data[:lookup_context]).to eq('existing')
    end


    it 'adds component' do
      subject = create_component(path: '/component_without_vm')
      expect(subject.view_model_default_data[:component]).to eq(subject)
    end
  end

  describe '#lookup_context' do
    it "setups a LookupContext according to the gem configuration" do
      allow(ComponentParty.configuration).to receive(:components_path).and_return('mockpath')
      expect(subject.lookup_context.view_paths.first.to_s).to match(/mockpath$/)
    end
  end
end
