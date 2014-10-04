# Configuration for Amazon S3
CarrierWave.configure do |config|

  config.enable_processing = true

# For testing, upload files to local `tmp` folder.
#   if Rails.env.test? || Rails.env.development?
#     #config.storage = :file
#     config.storage = :fog
#     config.root = "#{Rails.root}/public"
#   else
    # config.fog_directory = ENV['S3_BUCKET_NAME']

    config.fog_directory  = "#{Rails.env}-uhype"            # required
    # config.fog_host       = "http://s3.amazonaws.com"            # optional, defaults to nil
    # config.fog_public     = false # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}




    config.fog_credentials = {
        :provider => 'AWS',
        :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
        :region => ENV['S3_REGION'],
        :endpoint => ENV['S3_ENDPOINT']
    }


    # To let CarrierWave work on heroku
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage = :fog
  # end
end
