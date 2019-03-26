class CustomController::ViewModel < ActionComponent::Component::ViewModel
  def custom_method
    "Customizado #{custom_vm_data}"
  end
end
