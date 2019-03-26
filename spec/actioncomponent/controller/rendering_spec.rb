require 'rails_helper'

describe ActionComponent::Controller::Rendering do

  let(:mock_controller) {
    Class.new do
      prepend ActionComponent::Controller::Rendering

      def render_to_body(options = {})
         "original-method"
      end
    end.new
  }

  describe '#render_to_body' do
    it "calls super if there is no component to be rendered" do
      expect(mock_controller.render_to_body).to eq('original-method')
    end

    context 'rendering a component' do
      before(:each) do
        mock_component = double()
        allow(mock_component).to receive(:render).and_return('component-rendered')

        allow(ActionComponent::Component).to receive(:new).and_return(mock_component)
      end

      it "Renders a component" do
        expect(mock_controller.render_to_body(component: 'path')).to eq("component-rendered")
      end

      it 'Uses the view detected by rails as component' do
        expect(ActionComponent::Component).to receive(:new).with(hash_including(component_path: 'devise/sessions/new'))
        rails_options = {
          :prefixes=> ["devise/sessions", "devise", "application"],
          :template=> "new"
        }
        mock_controller.render_to_body(rails_options.merge(component: true))
      end

      it "Passes the component value as component_path" do
        expect(ActionComponent::Component).to receive(:new).with(hash_including(component_path: 'path'))
        expect(mock_controller.render_to_body(component: 'path')).to eq("component-rendered")
      end

      it 'Raises an error if component value is invalid' do
        expect {
          mock_controller.render_to_body(component: 342)
        }.to raise_error("Wrong value for 'component' key while calling render method. Argument class is Integer. Only String or true values are expected.")
      end
    end

  end
end
