require 'rails_helper'

describe ComponentParty::ActionView::ComponentRenderer do
  subject { described_class.new(
    ActionView::LookupContext.new([fixture_path('components')]),
    'my-component-path'
  )}

  describe '#create_view_model' do
    let(:context) { double('view-context') }
    let(:options) { {component: 'component_path', view_model_data: { key: 'value' }} }

    it 'Creates a empty view_model if no data is passed' do
      vm = subject.create_view_model(context, options)
      expect(vm).to be_an_instance_of(ComponentParty::ViewModel)
    end

    it 'Configures the view_model with data' do
      vm = subject.create_view_model(context, options)
      expect(vm.key).to eq('value')
    end

    it 'Configures the view_model with context' do
      vm = subject.create_view_model(context, options)
      expect(vm.view).to eq(context)
    end
  end

  specify '#decorate_template' do
    expect(subject.decorate_template(double)).to be_an_instance_of(ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator)
  end

  describe '#find_vm_class' do
    context 'when there is no custom view model option' do
      it "returns a default instance" do
        expect(subject.find_vm_class({ component: 'component/without/vm' })).to eq(ComponentParty::ViewModel)
        expect(subject.find_vm_class({ component: 'with_vm' })).to eq(ComponentParty::ViewModel)
      end
    end

    context 'when custom view model options exists' do
      it "searches for a constant with the vm path if option == true" do
        expect(subject.find_vm_class({ component: 'with_vm', custom_view_model: true })).to eq(WithVm::ViewModel)
      end

      it "uses the option itself otherwise" do
        expect(subject.find_vm_class({ component: 'with_vm', custom_view_model: WithVm::VmOnOptions })).to eq(WithVm::VmOnOptions)
      end
    end
  end

  describe '#template_path_from_component_path' do
    it "Joins the component path with the default template file name" do
      allow(ComponentParty.configuration).to receive(:template_file_name).and_return('templatefile')

      path = subject.template_path_from_component_path('my-long/path/on/folder')

      expect(path).to eq('my-long/path/on/folder/templatefile')
    end
  end
end
