class ServiceRequestsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   render json: response.parsed_response
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/ServiceReuest/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/ServiceReuest/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Service_request").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/ServiceReuest?_lastUpdated=ge2020-08-01&category=THERAPIES
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/ServiceReuest")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Service_request_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end
end
