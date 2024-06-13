class PractitionersController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Practitioner
  def index
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Practitioner")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Practitioners_list").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Practitioner/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Practitioner/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Practitioner").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Practitioner?{Parameter=Value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Practitioner")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Practitioners_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end
end
