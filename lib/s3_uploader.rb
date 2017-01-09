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

    obj = @uploader.object("#{file_name}.csv")
    csv_lines = GenerateSkuCsv.call
    returned_csv = CSV.generate(headers: true) do |csv|
      csv_lines.each do |line|
        csv << line
      end
    end
    obj.put body: returned_csv
  end
end
