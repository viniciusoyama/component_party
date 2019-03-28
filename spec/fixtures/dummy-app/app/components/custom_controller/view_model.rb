class CustomController::ViewModel < ComponentParty::Component::ViewModel
  def custom_method
    "Customizado #{custom_vm_data}"
  end
end
