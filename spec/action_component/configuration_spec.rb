require "spec_helper"

describe ActionComponent do
  describe "#configure" do
    before do
      ActionComponent.configure do |config|
        config.components_path = 'app/components'
      end
    end

    describe 'components_path configuration' do
      specify 'I can set my own path' do
        ActionComponent.configure do |config|
          config.components_path = 'my-path'
        end

        expect(ActionComponent.configuration.components_path).to eq('my-path')
      end

      specify 'it has /app/components as default' do
        expect(ActionComponent.configuration.components_path).to eq('app/components')
      end
    end

  end
end
