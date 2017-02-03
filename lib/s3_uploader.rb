class S3Uploader < AwsParent
  def initialize
    super
    Aws.config.update({ region: 'us-west-2' })
    @s3 = Aws::S3::Resource.new
    @uploader = @s3.bucket(ENV['UPLOAD_BUCKET'])
  end

  def call(title_team_player_path)
    ttp_file_name = "title_team_player-#{Time.now.to_i}.csv"
    @uploader.object(ttp_file_name).upload_file(title_team_player_path)
    root = "https://s3.amazonaws.com/#{ENV['UPLOAD_BUCKET']}/"

    return root + ttp_file_name
  end

  def self.sku_call
    Aws.config.update({ region: 'us-west-2' })
    @s3 = Aws::S3::Resource.new
    @uploader = @s3.bucket(ENV['CSV_UPLOAD_BUCKET'])
    file_name = "#{ENV['BUCKET_NAME']}sku_file-#{Time.now.to_i}"

    sku_file_path = GenerateSkuCsv.call
    obj = @uploader.object("#{file_name}.csv").upload_file(sku_file_path)
  end

  def self.upload_incomplete(incomplete_values)
    Aws.config.update({ region: 'us-west-2' })
    @s3 = Aws::S3::Resource.new
    @uploader = @s3.bucket(ENV['CSV_UPLOAD_BUCKET'])
    path = "/tmp/#{ENV['BUCKET_NAME']}-Missing-Lines-File-#{Time.now.to_i}.csv"
    file_name = "#{ENV['BUCKET_NAME']}-Missing-Lines-File-#{Time.now.to_i}.csv"
    File.new(path, "w")
    CSV.open(path, "wb") do |csv|
      incomplete_values.each do |line|
        csv << line
      end
    end
    obj = @uploader.object("#{file_name}").upload_file(path)
  end
end
