# Configuration for Amazon S3
CarrierWave.configure do |config|

# For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.enable_processing = true
    config.root = "#{Rails.root}/public"
  else
    config.fog_directory = ENV['S3_BUCKET_NAME']
    config.fog_credentials = {
        :provider => 'AWS',
        :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
        # :region => ENV['S3_REGION'],
        # :endpoint => ENV['S3_ENDPOINT']
    }

    # To let CarrierWave work on heroku
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage = :fog
  end
end
