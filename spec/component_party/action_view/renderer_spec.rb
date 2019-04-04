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

      def render(context, opts = {})
         "original-render"
      end
    end.new(ActionView::LookupContext.new([]))
  }

  describe '#initialize' do
    it 'Adds the component folder to the lookup context' do
      expect(mock_renderer.lookup_context.view_paths[0].to_s).to end_with('app/components')
    end
  end

  describe '#render' do
    it "calls super if there is no component to be rendered" do
      expect(mock_renderer.render('context', {})).to eq('original-render')
    end

    it "renders a component if key is provided" do
      mock_lookup = double('lookup')
      mock_component_renderer = double('component-renderer')
      opts = { component: 'component-path' }
      expect(mock_renderer).to receive(:lookup_context).and_return(mock_lookup)
      expect(mock_component_renderer).to receive(:render).with('context', opts)

      expect(ComponentParty::ActionView::ComponentRenderer).to receive(:new).with(mock_lookup, 'component-path').and_return(mock_component_renderer)

      mock_renderer.render('context', opts)

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
    context 'when component === true (using default route)' do
      it 'Uses the current controller/action name' do
        opts = { component: true, prefixes: ['users'], template: 'index' }
        mock_renderer.normalize_component_path!(context, opts)
        expect(opts[:component]).to eq('pages/users/index')
      end
    end

    context 'when value is a path' do
      context 'when path is absolute' do
        it 'returns the path itself' do
          opts = { component: 'path' }
          mock_renderer.normalize_component_path!(context, opts)
          expect(opts[:component]).to eq('path')
        end
      end

      context 'when path is relative' do
        it 'Appends the parent component when there is a current_component_path' do
          opts = { component: './test', caller_component_path: 'pages/users/index' }

          mock_renderer.normalize_component_path!(context, opts)
          expect(opts[:component]).to end_with('pages/users/index/test')
        end

        it "raises an exception if i'm not inside a component" do
          opts = { component: './test' }

          expect {
            mock_renderer.normalize_component_path!(context, { component: './test' })
          }.to raise_error("You cannot use a relative component importing outside a component's template.")
        end
      end

    end

    it 'Raises an error if component value is invalid' do
      expect {
        mock_renderer.normalize_component_path!(context, component: Object.new)
      }.to raise_error("Wrong value for 'component' key while calling render method. Argument class is Object. Only String or true values are expected.")
    end
  end
end
