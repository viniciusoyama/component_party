class CustomVm::ViewModel < ComponentParty::Component::ViewModel
  def hardcoded
    'Hardcoded Method'
  end

  def say_hi
    "Hi, #{name}"
  end

  def show_date
    "Date: #{h.l(Date.new(2019, 03, 29))}"
  end
end
