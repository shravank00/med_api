class AppointmentsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Appointment
  def index
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Appointment")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Appointments_list").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Appointment/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Appointment/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Appointment").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Appointment
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Appointment", body: appointment_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Appointment/{id}
  def update
    response = HTTParty.put("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Appointment/#{params[:id]}", body: appointment_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Appointment?{Parameter=Value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Appointment")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Appointments_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:participant, :appointment_type, :start, :end, :minutes_duration, :status)
  end
end
