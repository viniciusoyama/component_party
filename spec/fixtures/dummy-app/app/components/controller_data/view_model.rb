class ControllerData::ViewModel < ComponentParty::Component::ViewModel

  def formated_page
    "Current page: #{view.params[:page]}"
  end

  def formated_search
    "Searching for: #{view.params[:search]}"
  end

end
