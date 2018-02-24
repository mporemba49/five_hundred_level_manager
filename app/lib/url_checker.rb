class UrlChecker
  require "net/http"
  
  def self.url_exists?(url_string)
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    path = url.path if url.path.present?
    res = req.request_head(path || '/')
    if res.kind_of?(Net::HTTPRedirection)
      url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
    else
      ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
    end
  rescue Errno::ENOENT
    false #false if can't find the server
  end
  
end
