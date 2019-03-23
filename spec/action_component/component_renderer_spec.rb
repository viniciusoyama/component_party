require 'rails_helper'

describe ActionComponent::ComponentRenderer do
  subject do
    view_renderer = ActionView::Renderer.new(ActionView::LookupContext.new(
      [fixture_path('/components')]
    ))
    ActionComponent::ComponentRenderer.new(view_renderer)
  end

  describe '#render' do
    it "renders the component template" do
      rendered = subject.render(path: '/user-list')
      expect(rendered).to include('Listing Users')
    end
  end

  describe '#template_path_from_component_path' do
    it "Joins the component path with the default template file name" do
      path = subject.template_path_from_component_path('my-long/path/on/folder')

      expect(path).to eq('my-long/path/on/folder/template')
    end
  end


  describe '#lookup_context' do
    it "setups a LookupContext according to the gem configuration" do
      
    end
  end
end
