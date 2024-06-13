class CoveragesController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   render json: response.parsed_response
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Coverage/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Coverage/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Coverage").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Coverage
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Coverage", body: coverage_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Coverage?{Parameter=Value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Coverage")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Coverages_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def coverage_params
    params.require(:coverage).permit(:status, :identifier, :payor, :beneficiary, :type, :relationship)
  end
end
