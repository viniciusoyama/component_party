require 'rails_helper'

describe ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator do
  describe '#render' do
    it "Applies a div namespacing the component" do
      template = double
      view_model = double

      expect(template).to receive(:render).and_return("<div>Component</div>")

      decorated = ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator.new(template, 'css_namespace/nesting')

      rendered = decorated.render('ignores', { })

      expect(rendered).to include('Component')

      expect(rendered).to eq("<div data-component-path='css_namespace-nesting' >Component</div>")
    end
  end

  specify '#apply_html_namespacing' do
    subject = ComponentParty::ActionView::ComponentRenderer::TagWrapperDecorator.new(double, 'css_namespace/nesting')

    expected = %Q{<div class="test" style='color: #003;' data-component-path='css_namespace-nesting' >title<div>'}
    expect(subject.apply_html_namespacing(%Q{<div class="test" style='color: #003;'>title<div>'})).to eq(expected)


    expected = %Q{<span class="test" style='color: #003;' data-component-path='css_namespace-nesting' ><h1>title</h1> <divTesting></div><span>'}
    expect(subject.apply_html_namespacing(%Q{<span class="test" style='color: #003;'><h1>title</h1> <divTesting></div><span>'})).to eq(expected)


    expected = %Q{<img src='http://www.google.com.br/photo.jpg' data-component-path='css_namespace-nesting' />}
    expect(subject.apply_html_namespacing(%Q{<img src='http://www.google.com.br/photo.jpg'/>})).to eq(expected)
  end
end
