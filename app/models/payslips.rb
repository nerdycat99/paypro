class Payslips
  include ActiveModel::Model

  attr_accessor :all, :earliest_pay_period, :latest_pay_period, :total_overtime_pay, :total_ordinary_pay, :hourly_rate

  def initialize
    @all = []
    @total_overtime_pay = 0
    @total_ordinary_pay = 0
  end

  def add(payslip)
    calculate_hourly_rate(payslip) if @all.empty?
    all.push(payslip)
    set_earliest_pay_period(payslip)
    set_latest_pay_period(payslip)
    sum(:overtime, payslip) if payslip.cost_category == "overtime"
    sum(:ordinary, payslip) if payslip.cost_category == "ordinary"
  end

  def unique_employees
    all.uniq{| payslip | [payslip.employee_identifier]}
  end

  def calculate_hourly_rate(payslip)
    hours = ((payslip.applicable_to.to_time - payslip.applicable_from.to_time) / 1.hours)
    @hourly_rate = payslip.total_paid_no_oncosts.to_f / hours
  end

  def set_earliest_pay_period(payslip)
    applicable_from = payslip.applicable_from.to_date
    @earliest_pay_period =  if earliest_pay_period.nil? || applicable_from < earliest_pay_period
                              applicable_from
                            else
                              @earliest_pay_period
                            end
  end

  def set_latest_pay_period(payslip)
    applicable_to = payslip.applicable_to.to_date
    @latest_pay_period =  if latest_pay_period.nil? || applicable_to > latest_pay_period
                            applicable_to
                          else
                            @latest_pay_period
                          end
  end

  def sum(type, payslip)
    if type == :overtime
      @total_overtime_pay += payslip.total_paid_no_oncosts.to_f
    elsif type == :ordinary
      @total_ordinary_pay += payslip.total_paid_no_oncosts.to_f
    end
  end

  def overtime_hours
    total_overtime_pay / hourly_rate
  end

  def total_amount_paid
    total_overtime_pay + total_ordinary_pay
  end

end
