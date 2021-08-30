require 'spec_helper'

RSpec.describe Payslips, :type => :model do
  let(:params) { {"employee_identifier"=>"1066", "applicable_from"=>"2019-11-14T23:30:00.000Z", "applicable_to"=>"2019-11-15T01:30:00.000Z", "total_paid_no_oncosts"=>"75.00", "cost_category"=>"overtime"} }
  let(:payslip) { Payslip.new(params) }
  let(:params2) { {"employee_identifier"=>"1068", "applicable_from"=>"2019-11-30T22:00:00.000Z", "applicable_to"=>"2019-12-01T02:30:00.000Z", "total_paid_no_oncosts"=>"168.75", "cost_category"=>"overtime"} }
  let(:payslip2) { Payslip.new(params2) }
  let(:params3) { {"employee_identifier"=>"1068", "applicable_from"=>"2019-11-30T22:00:00.000Z", "applicable_to"=>"2019-12-01T02:30:00.000Z", "total_paid_no_oncosts"=>"500", "cost_category"=>"ordinary"} }
  let(:payslip3) { Payslip.new(params3) }

  subject {
    described_class.new
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it 'calculates the number of unique employees' do
    subject.add(payslip)
    subject.add(payslip2)
    subject.add(payslip3)
    expect(subject.unique_employees.count).to eq(2)
  end

  context 'when adding a payslip' do
    it 'adds a payslip to payslips' do
      subject.add(payslip)
      expect(subject.all).to eq [ payslip ]
    end

    it 'calculates the hourly rate' do
      subject.add(payslip)
      expect(subject.hourly_rate).to eq(37.5)
    end

    it 'sets the earliest pay period correctly' do
      subject.add(payslip)
      subject.add(payslip2)
      date = 'Thu, 14 Nov 2019'.to_date
      expect(subject.earliest_pay_period).to eq(date)
    end

    it 'sets the latest pay period' do
      subject.add(payslip)
      subject.add(payslip2)
      date = 'Sun, 01 Dec 2019'.to_date
      expect(subject.latest_pay_period).to eq(date)
    end

    it 'calculates the total overtime pay' do
      subject.add(payslip)
      subject.add(payslip2)
      expect(subject.total_overtime_pay).to eq(243.75)
    end

    it 'calculates the total ordinary pay' do
      subject.add(payslip)
      subject.add(payslip2)
      subject.add(payslip3)
      expect(subject.total_ordinary_pay).to eq(500)
    end

    it 'calculates the total paid' do
      subject.add(payslip)
      subject.add(payslip2)
      subject.add(payslip3)
      expect(subject.total_amount_paid).to eq(743.75)
    end

    it 'calculates the number of overtime hours' do
      subject.add(payslip)
      subject.add(payslip2)
      subject.add(payslip3)
      expect(subject.overtime_hours).to eq(6.5)
    end
  end
end