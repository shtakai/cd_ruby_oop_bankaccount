require 'test/unit'

module Interest
  INTEREST = (5.50).freeze
end

class BankAccount
  attr_reader :account_number
  attr_reader :checking_amount, :saving_amount
  @@accounts = 0

  def initialize
    @account_number = rand(100000)
    @checking_amount = 0
    @saving_amount = 0
    @@accounts += 1
    @interest = Interest::INTEREST
  end

  def deposit_saving amount
    @saving_amount += amount
  end

  def deposit_checking amount
    @checking_amount += amount
  end

  def withdraw_cheking amount
    raise InsufficientAmount if @checking_amount < amount
    @checking_amount -= amount
  end

  def withdraw_saving amount
    raise InsufficientAmount if @saving_amount < amount
    @saving_amount -= amount
  end

  def total_amount
    @checking_amount + @saving_amount
  end

  def account_information
    #@interest
    #"account_number: #{@account_number}  total_money: #{self.total_amount}  checking balance: #{@checking_amount}  saving balance: #{@saving_amount}  interest rate: #{@interest}"
    "account number: #{@account_number} total money: #{self.total_amount} checking balance: #{@checking_amount} saving balance: #{@saving_amount} interest rate: #{@interest}"
  end

  def self.accounts
    @@accounts
  end

  def self.reset_accounts
    @@accounts = 0
  end
end

class InsufficientAmount < StandardError
end



class TestBankAccount < Test::Unit::TestCase
  def setup
    @b = BankAccount.new
  end
  def test_initialize
    assert_instance_of(Fixnum, @b.account_number)
    assert_equal(0, @b.checking_amount)
    assert_equal(0, @b.saving_amount)
  end

  def test_return_checking_account
    assert_equal(0, @b.checking_amount)
  end

  def test_return_saving_account
    assert_equal(0, @b.saving_amount)
  end

  def test_deposit_saving
    @b.deposit_saving 10000
    assert_equal(10000, @b.saving_amount)
  end

  def test_deposit_checking
    @b.deposit_checking 2000
    assert_equal(2000, @b.checking_amount)
  end

  def test_withdraw_checking_sufficient
    @b.deposit_checking 1000
    assert_equal(100, @b.withdraw_cheking(900))
  end

  def test_withdraw_check_insufficient
    @b.deposit_checking 1000
    assert_raise(InsufficientAmount) {@b.withdraw_cheking 1001}
  end

  def test_withdraw_saving_sufficient
    @b.deposit_saving 1000
    assert_equal(10, @b.withdraw_saving( 990 ))
  end

  def test_withdraw_saving_insufficient
    @b.deposit_saving 2000
    assert_raise(InsufficientAmount) {@b.withdraw_saving(2001)}
  end

  def test_display_money
    @b.deposit_saving 1000
    @b.deposit_checking 500
    assert_equal(@b.total_amount, 1500)
  end

  def test_show_accounts
    BankAccount.reset_accounts
    c = BankAccount.new
    assert_equal(1, BankAccount.accounts)
  end

  def test_fail_show_interest
    assert_raise(NoMethodError) {@b.interest}
  end

  def test_show_accouunt_information
    #assert_equal(@b.account_information, Interest::INTEREST)
    assert_match(/account number:\s*\d+\s*total money:\s*\d+\s*checking balance:\s*\d+\s*saving balance:\s*\d+\s*interest rate:\s*\d+\s*/, @b.account_information)
    #assert_match(/.*/, @b.account_information)
  end

  def test_private_access
    assert_raise(NoMethodError) {@b.account_number=100}
    assert_raise(NoMethodError) {@b.checking_amount=100}
    assert_raise(NoMethodError) {@b.saving_amount=100}
    assert_raise(NoMethodError) {@b.interest=100}
  end
end

