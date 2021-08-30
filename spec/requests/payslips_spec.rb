require 'rails_helper'

RSpec.describe "Payslips", type: :request do

  let(:params) { {"employee_identifier"=>"1066", "applicable_from"=>"2019-11-14T23:30:00.000Z", "applicable_to"=>"2019-11-15T01:30:00.000Z", "total_paid_no_oncosts"=>"75.00", "cost_category"=>"overtime"} }
  let(:payslip) { Payslip.new(params) }
  let(:payslips) { Payslips.new }

  before do
    payslips.add(payslip)
    PayslipsController.any_instance.stub(:selected_file).and_return("source_file.csv")
    PayslipsController.any_instance.stub(:generate_payslips_for).and_return(payslips)
  end

  describe "POST /create" do
    context "when the csv file is valid" do

      before do
        PayslipsController.any_instance.stub(:valid_csv?).and_return(true)
      end

      it "shows the user the payslip information page" do
        post "/payslips"
        expect(response.body).to include("payslip information")
      end
    end

    context "when the csv file is NOT valid" do
      before do
        PayslipsController.any_instance.stub(:valid_csv?).and_return(false)
      end
    end
  end
end
