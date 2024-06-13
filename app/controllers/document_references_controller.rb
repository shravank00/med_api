class DocumentReferencesController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/DocumentReference?patient={id}  Retrieve all the documents for patient id
  def index
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/DocumentReference")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Document_references_list").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/DocumentReference/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/DocumentReference/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Document_references").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/DocumentReference?{Parameter=Value}
  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/DocumentReference?patient=(PatientID)&category=ccda
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/DocumentReference")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Document_references_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end
end
