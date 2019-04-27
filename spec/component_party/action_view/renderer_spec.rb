require 'rails_helper'

describe ComponentParty::ActionView::Renderer do
  let(:context) { double('context') }
  let(:mock_renderer) {
    Class.new do
      prepend ComponentParty::ActionView::Renderer

      attr_reader :lookup_context

      def initialize(lookup_context)
        @lookup_context = lookup_context
      end

      def render_to_object(context, opts = {})
         "original-render"
      end
    end.new(ActionView::LookupContext.new([]))
  }

  describe '#render_to_object' do
    it "calls super if there is no component to be rendered" do
      expect(mock_renderer.render_to_object('context', {})).to eq('original-render')
    end

    it "renders a component if key is provided" do
      mock_lookup = double('lookup')
      mock_component_renderer = double('component-renderer')
      opts = { component: 'component-path' }
      expect(mock_renderer).to receive(:lookup_context).and_return(mock_lookup)
      expect(mock_component_renderer).to receive(:render).with('context', opts)

      expect(ComponentParty::ActionView::ComponentRenderer).to receive(:new).with(mock_lookup, 'component-path').and_return(mock_component_renderer)

      mock_renderer.render_to_object('context', opts)

    end
  end

  describe '#normalize_data_for_component_rendering' do
    it 'normalizes the component path' do
      opts = { component: 'component-path' }
      expect(mock_renderer).to receive(:normalize_component_path!).with(context, opts)
      mock_renderer.normalize_data_for_component_rendering!(context, opts)
    end

    it 'changes context to have the new component path' do
      opts = { component: 'component-path' }
      context.instance_variable_set('@current_component_path', 'old-path')

      allow(mock_renderer).to receive(:normalize_component_path!)

      mock_renderer.normalize_data_for_component_rendering!(context, opts)

      expect(context.instance_variable_get('@current_component_path')).to eq('component-path')
    end
  end

  describe '#normalize_component_path!' do
    context 'when component == true (using default route)' do
      it 'changes the option to be the current controller/action path' do
        opts = { component: true, prefixes: ['users'], template: 'index' }
        mock_renderer.normalize_component_path!(context, opts)
        expect(opts[:component]).to eq('users/index')
      end

      it "Sets pages as preffix" do
        opts = { component: true, prefixes: ['users'], template: 'index' }
        mock_renderer.normalize_component_path!(context, opts)
        expect(opts[:prefixes]).to eq(['pages'])
      end
    end

    context 'when value is a String' do
      it 'changes the prefix to to empty' do
        opts = { component: 'path' }
        mock_renderer.normalize_component_path!(context, opts)
        expect(opts[:prefixes]).to eq([])
      end
    end
  end
end
