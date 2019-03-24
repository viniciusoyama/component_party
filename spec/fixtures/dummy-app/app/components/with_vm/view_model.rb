class WithVm::ViewModel
  attr_accessor :number
  attr_accessor :word

  def initialize(number:, word:)
    @word = word
    @number = number
  end
end
