class Payslips
  # include ActiveModel::Model

  attr_accessor :all

  def initialize
    @all = []
  end

  def add(payslip)
    all.push(payslip)
  end

end