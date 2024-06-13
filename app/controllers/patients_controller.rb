class PatientsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Patient
  def index
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Patient")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Patients_list").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Patient/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Patient/#{params[:id]}")
    if response.code == 200
      family_name = response['resource']['name'][0]['family']
      given_name = response['resource']['name'][0]['given']
      s3_bucket_url = AwsS3Service.new("Patient").upload_file(response.body)

      # Include family_name, given_name, and s3_bucket_url in the response
      render json: { family_name: family_name, given_name: given_name, s3_bucket_url: s3_bucket_url }
    else
      render json: { error: 'Patient not found' }, status: response.code
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Patient
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Patient", body: patient_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Patient/{id}
  def update
    response = HTTParty.put("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Patient/#{params[:id]}", body: patient_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Patient?{Parameter=Value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Patient")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Patient_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :type, :description, :birthdate, :email, :family, :given, :phone)
  end
end
