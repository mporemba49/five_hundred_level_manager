class AwsParent
  def initialize
    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_KEY'])
    })
  end
end
