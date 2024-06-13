class DiagnosticReportsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   render json: response.parsed_response
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/DiagnosticReport/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/DiagnosticReport/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Diagnostic_report").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}ema/fhir/v2/DiagnosticReport?requisition=279720
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/DiagnosticReport")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Diagnostic_reports_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end
end
