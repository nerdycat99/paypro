require 'rails_helper'

RSpec.describe "Payslips", type: :request do

  let(:payslip) { "this is a payslip" }
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

      it "does NOT show the user the payslip information page" do
        get "/payslips"
        expect(response).not_to redirect_to("/index")
      end
    end
  end


  describe "GET /index" do

    context "csv file valid" do
      it "responds with status code 200" do
        get "/payslips"
        expect(response.code).to eq("200")
      end

    end
  end

end
