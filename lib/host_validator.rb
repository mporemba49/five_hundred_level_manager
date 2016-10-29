class HostValidator < AwsParent
  attr_reader :validator
  attr_accessor :league_and_teams

  def initialize
    super
    @validator = Aws::S3::Client.new
  end

  def objects
    return @objects if @objects

    objs = []
    @validator.list_objects(bucket: ENV['BUCKET_NAME']).each do |page|
      contents = page.contents
      contents.each do |aws_object|
        league_and_team = aws_object.key.split('/')[0..1]
        objs << page.contents if league_and_teams.include?(league_and_team)
      end
    end

    @objects = objs
  end

  def paths
    @paths ||= objects.map { |object| object.key.split('/')[0...-1].join('/') + '/' }.uniq
  end

  def valid_folder?(path)
    encoded_path = path.gsub("(","\\(")
    encoded_path = encoded_path.gsub(")","\\)")
    paths.join.match(encoded_path)
  end
end
