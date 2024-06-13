# app/services/aws_s3_service.rb
class AwsS3Service
  def initialize(obj_name)
    @credentials = Aws::Credentials.new(
      Rails.application.credentials.aws[:access_key_id],
      Rails.application.credentials.aws[:secret_access_key]
    )
    @s3_client = Aws::S3::Resource.new(
      region: Rails.application.credentials.aws[:aws_region],
      credentials: @credentials
    )
    @object_key = "#{obj_name}_#{Time.now.strftime('%Y%m%d%H%M%S%L')}.txt"
  end

  def upload_file(file_body)
    p @object_key
    obj = @s3_client.bucket(Rails.application.credentials.aws[:s3_bucket_name]).object(@object_key)
    obj.put(body: file_body)
    obj.public_url
  end
end
