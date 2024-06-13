class OrganizationsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   render json: response.parsed_response
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Organization/{id}  /pay|651
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Organization/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Organization").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Organization
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Organization", body: organization_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Organization?type=pay&identifier=payerId|09102
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Organization")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Organizations_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:identifier, :active, :type, :name, :address)
  end
end
