class TestingController < ApplicationController
  def default_component
    if params[:cancel_layout]
      render component: true, view_model_data: { custom_vm_data: 'custom vm data' }, layout: false
    else
      render component: true, view_model_data: { custom_vm_data: 'custom vm data' }
    end

  end

  def custom_component
    render component: 'custom_controller', view_model_data: { custom_vm_data: 'custom vm data' }
  end
end
