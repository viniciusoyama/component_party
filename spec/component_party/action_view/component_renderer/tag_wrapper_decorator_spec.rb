require 'rails_helper'

describe ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator do
  describe '#render' do
    it "Applies a div namespacing the component" do
      template = double
      view_model = double

      expect(template).to receive(:render).and_return("<div>Component</div>")

      decorated = ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator.new(template)

      rendered = decorated.render('ignores', { component: 'css_namespace/nesting'})

      expect(rendered).to include('Component')

      html = Nokogiri(rendered)
      expect(html.children.count).to be(1)
      wrapper = html.children.first
      expect(wrapper.attr('class')).to eq('component')
      expect(wrapper.attr('data-component-path')).to eq('css_namespace-nesting')
    end
  end
end
