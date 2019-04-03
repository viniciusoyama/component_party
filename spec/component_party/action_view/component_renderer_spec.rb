require 'rails_helper'

describe ComponentParty::ActionView::ComponentRenderer do
  subject { described_class.new(
    ActionView::LookupContext.new([])
  )}

  describe '#initialize' do
    it 'Adds the component folder to the lookup context' do
      expect(subject.lookup_context.view_paths.first.to_s).to end_with('app/components')
    end
  end

  describe '#render' do
    subject { described_class.new(
      ActionView::LookupContext.new([fixture_path('components')])
    )}

    it "renders the component template" do
      rendered = subject.render(double, { component: 'user_list'})
      expect(rendered).to include('Listing Users')
    end

    it "passes the vm as locals" do
      rendered = subject.render(double, { component: 'component_rendering_vm_testing', view_model_data: { number: 'two' }})
      expect(rendered).to include('View Model Number: two')
    end

    it "passes the current_component_path as local" do
      rendered = subject.render(double, { component: 'component_rendering_caller_testing', current_component_path: 'caller/path'})
      expect(rendered).to include('Caller locals: caller/path')
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
