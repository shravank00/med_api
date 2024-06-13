class ConditionsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   render json: response.parsed_response
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Condition/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Condition/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Condition").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Condition
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Condition", body: condition_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Condition
  def update
    response = HTTParty.put("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Condition/#{params[:id]}", body: condition_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Condition?[parameter={value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Condition")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Conditions_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def condition_params
    params.require(:condition).permit(:clinical_status, :subject, :code, :recorded_date)
  end
end
