class LocationsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Location
  def index
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Location")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Locations_list").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Location/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Location/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Location").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Location?{Parameter=Value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Location")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Locations_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end
end
