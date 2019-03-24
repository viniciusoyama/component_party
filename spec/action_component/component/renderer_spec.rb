require 'rails_helper'

describe ActionComponent::Component::Renderer do
  let(:view_model) { double() }
  subject do
    ActionComponent::Component::Renderer.new(ActionView::LookupContext.new(
      [fixture_path('/components')]
    ), view_model)
  end

  describe '#render' do
    it "renders the component template" do
      rendered = subject.render(component_path: '/user_list')
      expect(rendered).to include('Listing Users')
    end
  end

  describe '#create_view_context' do
    let(:context) { subject.create_view_context }

    it 'exposes helpers' do
      expect(context.helper).to respond_to(:l)
      expect(context.h).to respond_to(:users_path)
      expect(context.helper).to respond_to(:t)
    end

    context 'exposing view model' do
      it 'exposes ActionComponent::ViewModel by default' do
        expect(context.vm).to be(view_model)
        expect(context.view_model).to be(view_model)
      end
    end
  end

  describe '#template_path_from_component_path' do
    it "Joins the component path with the default template file name" do
      allow(ActionComponent.configuration).to receive(:template_file_name).and_return('templatefile')

      path = subject.template_path_from_component_path('my-long/path/on/folder')

      expect(path).to eq('my-long/path/on/folder/templatefile')
    end
  end


end
