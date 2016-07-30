class AwsParent
  def initialize
    Aws.config.update({
      region: 'us-west-2',
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_KEY'])
    })
  end
end
