class CustomVm::ViewModel < ComponentParty::ViewModel
  def hardcoded
    'Hardcoded Method'
  end

  def say_hi
    "Hi, #{name}"
  end

  def show_date
    "Date: #{view.l(Date.new(2019, 03, 29))}"
  end
end
