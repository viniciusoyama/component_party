require 'rails_helper'

describe ComponentParty::Component::Renderer do
  let(:helper_object) do
    Class.new do
      def l
      end

      def t
      end
    end.new
  end

  let(:view_model) {
    vm = double()
    allow(vm).to receive(:h).and_return(helper_object)
    allow(vm).to receive(:helper).and_return(helper_object)
    vm
  }

  let(:component) { double(
    view_model: view_model,
    lookup_context: ActionView::LookupContext.new([fixture_path('/components')]),
    path: 'no-op'
  )}

  subject do
    ComponentParty::Component::Renderer.new(component)
  end

  describe '#render' do
    context 'without layout' do
      it "renders the component template" do
        allow(component).to receive(:path).and_return('/user_list')
        rendered = subject.render(double, {})
        expect(rendered).to include('Listing Users')
      end
    end
  end

  describe '#template_path_from_path' do
    it "Joins the component path with the default template file name" do
      allow(ComponentParty.configuration).to receive(:template_file_name).and_return('templatefile')

      path = subject.template_path_from_component_path('my-long/path/on/folder')

      expect(path).to eq('my-long/path/on/folder/templatefile')
    end
  end

  describe ComponentParty::Component::Renderer::ComponentTemplateDecorator do
    describe '#render' do
      it 'ignores the current context and uses view model instead' do
        template = double
        view_model = double

        expect(template).to receive(:render).with(view_model, "options")

        decorated = ComponentParty::Component::Renderer::ComponentTemplateDecorator.new(template, view_model, '')

        decorated.render('ignores', 'options')
      end

      it "Applies a div namespacing the component" do
        template = double
        view_model = double

        expect(template).to receive(:render).and_return("<div>Component</div>")

        decorated = ComponentParty::Component::Renderer::ComponentTemplateDecorator.new(template, view_model, '/css_namespace/nesting')

        rendered = decorated.render('ignores')

        expect(rendered).to include('Component')

        html = Nokogiri(rendered)
        expect(html.children.count).to be(1)
        wrapper = html.children.first
        expect(wrapper.attr('class')).to eq('component')
        expect(wrapper.attr('data-component-path')).to eq('css_namespace-nesting')
      end
    end
  end
end
