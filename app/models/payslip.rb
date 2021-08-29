class Payslip
  include ActiveModel::Model

  attr_accessor :employee_identifier,:applicable_from, :applicable_to, :total_paid_no_oncosts, :cost_category

  def initialise(args)
  end

end