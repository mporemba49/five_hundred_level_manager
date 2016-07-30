class S3Downloader < AwsParent
  def initialize
    super
    @s3 = Aws::S3::Client.new
  end

  def call(path)
    save_file = "/tmp/#{path.split('/')[-1]}"
    File.open(save_file, 'wb') do |file|
      @s3.get_object({
        bucket: ENV['UPLOAD_BUCKET'],
        key: "title_team_player-1469838772.csv"},
        target: file)
    end

    save_file
  end
end
