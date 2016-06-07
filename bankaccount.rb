class BankAccount
  attr_reader :account_number
  attr_reader :checking_amount, :saving_amount

  def initialize
    @account_number = rand(100000)
    @checking_amount = 0
    @saving_amount = 0
  end

end
