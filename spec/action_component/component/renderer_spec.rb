require 'rails_helper'

describe ActionComponent::Component::Renderer do

  describe '#render' do
    subject do
      ActionComponent::Component::Renderer.new(ActionView::LookupContext.new(
        [fixture_path('/components')]
      ))
    end

    it "renders the component template" do
      rendered = subject.render(path: '/user-list')
      expect(rendered).to include('Listing Users')
    end
  end

  describe '#template_path_from_component_path' do
    it "Joins the component path with the default template file name" do
      allow(ActionComponent.configuration).to receive(:template_file_name).and_return('templatefile')

      path = subject.template_path_from_component_path('my-long/path/on/folder')

      expect(path).to eq('my-long/path/on/folder/templatefile')
    end
  end


  describe '#lookup_context' do
    it "setups a LookupContext according to the gem configuration" do
      allow(ActionComponent.configuration).to receive(:components_path).and_return('mockpath')
      expect(subject.lookup_context.view_paths.first.to_s).to match(/mockpath$/)
    end
  end
end
