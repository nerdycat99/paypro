class PayslipsController < ApplicationController
  require 'csv'

  def create
    return redirect_back(fallback_location: root_path, notice: "There was a problem with file") unless valid_csv?
    payslips = Payslips.new
    @payslips = generate_payslips_for(selected_file, payslips)
    render :index
  end

  def index
    @payslips
  end

  private

  def selected_file
    @selected_file = params['file'].tempfile
  end

  def valid_csv?
    params['file'].content_type == "text/csv"
  end

  def generate_payslips_for(selected_file, payslips)
    CSV.foreach(selected_file, headers: true) do |row|
      payslip = Payslip.new(row.to_h)
      payslips.add(payslip)
    end
    payslips
  end

end
