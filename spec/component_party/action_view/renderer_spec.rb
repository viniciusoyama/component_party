require 'rails_helper'

describe ComponentParty::ActionView::Renderer do

  let(:mock_renderer) {
    Class.new do
      prepend ComponentParty::ActionView::Renderer

      def render(context, opts = {})
         "original-render"
      end
    end.new
  }

  describe '#render' do
    it "calls super if there is no component to be rendered" do
      expect(mock_renderer.render('context', {})).to eq('original-render')
    end

    it "renders a component if key is provided" do
      mock_lookup = double('lookup')
      mock_component_renderer = double('component-renderer')
      opts = { caller_component_context: double(), component: 'component-path' }
      expect(mock_renderer).to receive(:lookup_context).and_return(mock_lookup)
      expect(mock_component_renderer).to receive(:render).with('context', opts)

      expect(ComponentParty::ActionView::ComponentRenderer).to receive(:new).with(mock_lookup, 'component-path').and_return(mock_component_renderer)

      mock_renderer.render('context', opts)

    end
  end

  describe '#normalize_component_args!' do
    context 'when component === true (using default route)' do
      it 'Uses the current controller/action name' do
        opts = { component: true, prefixes: ['users'], template: 'index' }
        mock_renderer.normalize_component_args!(opts)
        expect(opts[:component]).to eq('pages/users/index')
      end
    end

    context 'when value is a path' do
      context 'when path is absolute' do
        it 'returns the path itself' do
          opts = { component: 'path' }
          mock_renderer.normalize_component_args!(opts)
          expect(opts[:component]).to eq('path')
        end
      end

      context 'when path is relative' do
        it 'Appends the parent component path with its lookup_context base path' do
          opts = { component: './test', current_component_path: 'pages/users/index' }
          mock_renderer.normalize_component_args!(opts)
          expect(opts[:component]).to end_with('pages/users/index/test')
        end

        it "raises an exception if i'm not inside a component" do
          opts = { component: './test' }

          expect {
            mock_renderer.normalize_component_args!({ component: './test' })
          }.to raise_error("You cannot use a relative component importing outside a component's template.")
        end
      end

    end

    it 'Raises an error if component value is invalid' do
      expect {
        mock_renderer.normalize_component_args!(component: Object.new)
      }.to raise_error("Wrong value for 'component' key while calling render method. Argument class is Object. Only String or true values are expected.")
    end
  end
  #
  # describe '#render_component' do
  #   before(:each) do
  #     mock_component = double()
  #     allow(mock_component).to receive(:render).with(any_args).and_return('component-rendered')
  #
  #     allow(ComponentParty::Component).to receive(:new).and_return(mock_component)
  #   end
  #
  #   it "Renders a component" do
  #     expect(mock_controller.render_component(path: 'path', view_model_data: {}, options: {})).to eq("component-rendered")
  #   end
  #
  #   it "Passes the path to the component" do
  #     expect(ComponentParty::Component).to receive(:new).with(hash_including(path: 'path'))
  #     mock_controller.render_component(path: 'path', view_model_data: {}, options: {})
  #   end
  #
  #   it "Passes the current controller as view model data" do
  #     expect(ComponentParty::Component).to receive(:new).with(hash_including(view_model_data: hash_including({ c: mock_controller, controller: mock_controller })))
  #     mock_controller.render_component(path: 'path', view_model_data: {}, options: {})
  #   end
  #
  #   it "Passes custom view model data" do
  #     expect(ComponentParty::Component).to receive(:new).with(hash_including(view_model_data: hash_including({
  #       c: mock_controller,
  #       controller: mock_controller,
  #       new_arg: 2,
  #       more_arg: 'text'
  #     })))
  #     mock_controller.render_component(path: 'path', view_model_data: { new_arg: 2, more_arg: 'text'}, options: {})
  #   end
  #
  #   it "Passes a lookup_context with view_paths merged with components path" do
  #     expect(ComponentParty::Component).to receive(:new).with(hash_including(lookup_context: 'lookup'))
  #     allow(mock_controller).to receive(:render_component_lookup_context).and_return('lookup')
  #
  #     mock_controller.render_component(path: 'path', view_model_data: { new_arg: 2, more_arg: 'text'}, options: {})
  #   end

  # end
end
