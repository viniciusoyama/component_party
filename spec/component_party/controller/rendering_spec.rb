require 'rails_helper'

describe ComponentParty::Controller::Rendering do

  let(:mock_controller) {
    Class.new do
      prepend ComponentParty::Controller::Rendering

      def render_to_body(options = {})
         "original-method"
      end

      def view_paths
        ['path1', 'path2']
      end

      def view_context
        Object.new
      end
    end.new
  }

  describe '#render_to_body' do
    it "calls super if there is no component to be rendered" do
      expect(mock_controller.render_to_body).to eq('original-method')
    end

    it "renders a component if key is provided" do
      options = {
        view_model_data: { data: 3 },
        component: 'my-component'
      }
      expect(mock_controller).to receive(:get_path_for_component_render_options).with(options).and_return('components/my-component')
      expect(mock_controller).to receive(:render_component).with(
        path: 'components/my-component',
        view_model_data: options[:view_model_data],
        options: options
      )
      mock_controller.render_to_body(options)
    end
  end

  describe '#get_path_for_component_render_options' do
    context 'default component path' do
      it 'Uses the current controller/action name' do
        component_path = mock_controller.get_path_for_component_render_options(component: true, prefixes: ['users'], template: 'index')
        expect(component_path).to eq('pages/users/index')
      end
    end

    context 'passing a path' do
      it 'Uses the current controller/action name' do
        component_path = mock_controller.get_path_for_component_render_options(component: 'path')
        expect(component_path).to eq('path')
      end
    end


    it 'Raises an error if component value is invalid' do
      expect {
        mock_controller.get_path_for_component_render_options(component: Object.new)
      }.to raise_error("Wrong value for 'component' key while calling render method. Argument class is Object. Only String or true values are expected.")
    end
  end

  describe '#render_component' do
    before(:each) do
      mock_component = double()
      allow(mock_component).to receive(:render).with(any_args).and_return('component-rendered')

      allow(ComponentParty::Component).to receive(:new).and_return(mock_component)
    end

    it "Renders a component" do
      expect(mock_controller.render_component(path: 'path', view_model_data: {}, options: {})).to eq("component-rendered")
    end

    it "Passes the path to the component" do
      expect(ComponentParty::Component).to receive(:new).with(hash_including(path: 'path'))
      mock_controller.render_component(path: 'path', view_model_data: {}, options: {})
    end

    it "Passes the current controller as view model data" do
      expect(ComponentParty::Component).to receive(:new).with(hash_including(view_model_data: hash_including({ c: mock_controller, controller: mock_controller })))
      mock_controller.render_component(path: 'path', view_model_data: {}, options: {})
    end

    it "Passes custom view model data" do
      expect(ComponentParty::Component).to receive(:new).with(hash_including(view_model_data: hash_including({
        c: mock_controller,
        controller: mock_controller,
        new_arg: 2,
        more_arg: 'text'
      })))
      mock_controller.render_component(path: 'path', view_model_data: { new_arg: 2, more_arg: 'text'}, options: {})
    end

    it "Passes a lookup_context with view_paths merged with components path" do
      expect(ComponentParty::Component).to receive(:new).with(hash_including(lookup_context: 'lookup'))
      allow(mock_controller).to receive(:render_component_lookup_context).and_return('lookup')

      mock_controller.render_component(path: 'path', view_model_data: { new_arg: 2, more_arg: 'text'}, options: {})
    end

  end
end
