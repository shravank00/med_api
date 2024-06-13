class ChargeItemsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/ChargeItem
  def index
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/ChargeItem")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Charge_items_list").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/ChargeItem/CHG|{id}
  def show
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/ChargeItem/#{params[:id]}")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Charge_item").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/ChargeItem
  def create
    response = HTTParty.post("#{BASE_URL}/#{FIRM}/ema/fhir/v2/ChargeItem", body: charge_item_params.to_json, headers: { 'Content-Type' => 'application/json' })
    render json: response.parsed_response, status: response.code
  end

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/ChargeItem?parameter={value}
  def search
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/ChargeItem")
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Charge_items_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end

  private

  def charge_item_params
    params.require(:charge_item).permit(:description, :amount, :patient_id)
  end
end
