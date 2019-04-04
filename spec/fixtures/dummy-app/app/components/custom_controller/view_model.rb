class CustomController::ViewModel < ComponentParty::ViewModel
  def custom_method
    "Customizado #{custom_vm_data}"
  end
end
