class MedicationStatementsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   render json: response.parsed_response
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/MedicationStatement/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/MedicationStatement/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Medication_statement").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/MedicationStatement
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/MedicationStatement", body: medication_statement_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/MedicationStatement
  def update
    response = HTTParty.put("#{BASE_URL}/#{FIRM}/ema/fhir/v2/MedicationStatement/#{params[:id]}", body: medication_statement_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/MedicationStatement?parameter={value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/MedicationStatement")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Medication_statements_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def medication_statement_params
    params.require(:medication_statement).permit(:status. :subject, :medication_codeable_concept)
  end
end
