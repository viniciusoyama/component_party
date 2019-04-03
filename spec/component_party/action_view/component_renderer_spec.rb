require 'rails_helper'

describe ComponentParty::ActionView::ComponentRenderer do
  subject { described_class.new(
    ActionView::LookupContext.new([fixture_path('components')])
  )}

  describe '#initialize' do
    it 'Adds the component folder to the lookup context' do
      expect(subject.lookup_context.view_paths[1].to_s).to end_with('app/components')
    end
  end

  describe '#render' do
    it "renders the component template" do
      rendered = subject.render(double, { component: 'user_list'})
      expect(rendered).to include('Listing Users')
    end

    it "passes the vm as locals" do
      context = double('view context')
      expect(subject).to receive(:create_view_model).with('component_rendering_vm_testing', { number: 'two' }, context).and_return(OpenStruct.new(number: 'two'))

      rendered = subject.render(context, { component: 'component_rendering_vm_testing', view_model_data: { number: 'two' }})

      expect(rendered).to include('View Model Number: two')
    end

    it "passes the current_component_path as local" do
      rendered = subject.render(double, { component: 'component_rendering_caller_testing', current_component_path: 'caller/path'})
      expect(rendered).to include('Caller locals: caller/path')
    end
  end

  describe '#create_view_model' do
    let(:context) { double('view-context') }

    it 'Creates a empty view_model if no data is passed' do
      vm = subject.create_view_model('componentn_path', nil, context)
      expect(vm).to be_an_instance_of(ComponentParty::ViewModel)
    end

    it 'Configures the view_model with data' do
      vm = subject.create_view_model('componentn_path', { key: 'value' }, context)
      expect(vm.key).to eq('value')
    end

    it 'Configures the view_model with context' do
      vm = subject.create_view_model('componentn_path', { key: 'value' }, context)
      expect(vm.view).to eq(context)
    end
  end


  describe '#find_vm_class' do
    it "returns a default instance if custom vm file doesn't exists" do
      expect(subject.find_vm_class('component/without/vm')).to eq(ComponentParty::ViewModel)
    end

    it "searches for a constant with the vm path" do
      expect(subject.find_vm_class('/with_vm')).to eq(WithVm::ViewModel)
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
