class S3Downloader < AwsParent
  def initialize
    super
    Aws.config.update({ region: 'us-west-2' })
    @s3 = Aws::S3::Client.new
  end

  def call(path)
    key = path.split('/')[-1]
    save_file = "/tmp/#{key}"
    File.open(save_file, 'wb') do |file|
      @s3.get_object({
        bucket: ENV['UPLOAD_BUCKET'],
        key: key},
        target: file)
    end

    save_file
  end
end
