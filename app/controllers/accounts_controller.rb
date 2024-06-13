class AccountsController < ApplicationController
  include HTTParty

  DEV_URL = "https://stage.ema-api.com/ema-dev/firm/"
  BASE_URL = 'http://stage.ema-api.com/ema-training/firm'
  FIRM = "dermassoc"

  # {baseurl}/{firm_url_prefix}/ema/fhir/v2/Account?patient=39291
  def search
    query = params[:query]
    response = HTTParty.get("#{BASE_URL}/#{FIRM}/ema/fhir/v2/Account", query: { q: query })
    if response.code == 200
      s3_bucket_url = AwsS3Service.new("Account_filter").upload_file(response.body)
      render json: { s3_bucket_url: s3_bucket_url }
    else
      render json: response.parsed_response
    end
  end
end
