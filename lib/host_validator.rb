class HostValidator
  attr_reader :validator

  def initialize
    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_KEY'])
    })
    @validator = Aws::S3::Client.new
  end

  def objects
    return @objects if @objects

    objs = []
     @validator.list_objects(bucket: BUCKET_NAME).each do |response|
      objs += response.contents
    end

    @objects = objs
  end

  def paths
    @paths ||= objects.map { |object| object.key.split('/')[0...-1].join('/') + '/' }.uniq
  end

  def validate_folder(path)
    encoded_path = path.gsub("(","\\(")
    encoded_path = encoded_path.gsub(")","\\)")
    paths.join.match(encoded_path)
  end
end
