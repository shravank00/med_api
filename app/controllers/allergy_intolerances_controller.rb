class AllergyIntolerancesController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # def index
  #   response = HTTParty.get(BASE_URL)
  #   if response.code == 200
  #     s3_bucket_url = AwsS3Service.new("Allergy_intolerances_list").upload_file(response.body)
  #     render json: { s3_bucket_url: s3_bucket_url }
  #   else
  #     render json: response.parsed_response
  #   end
  # end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/AllergyIntolerance/{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/AllergyIntolerance/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Allergy_intolerance").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/AllergyIntolerance
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/AllergyIntolerance", body: allergy_intolerance_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/AllergyIntolerance
  def update
    response = HTTParty.put("#{BASE_URL}/#{FIRM}/ema/fhir/v2/AllergyIntolerance/#{params[:id]}", body: allergy_intolerance_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/AllergyIntolerance?[parameter={value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/AllergyIntolerance")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Allergy_intolerances_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def allergy_intolerance_params
    params.require(:allergy_intolerance).permit(:clinical_status, :code, :reaction, :patient_id, :recorded_date)
  end
end