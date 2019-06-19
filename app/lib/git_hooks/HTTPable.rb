require 'net/http'
require 'uri'

module GitHooks
  module HTTPable
    @base_uri = "https://api.github.com/repos/michael-schneider3/sample_app/issues"

    def self.githooks_defaults(path)
      whole_uri = @base_uri + path
      encoded_uri = URI.encode(whole_uri)
      {defaults: {uri: encoded_uri, token: ENV["GITHUB_TOKEN"]}}
    end
    
    def self.remove_label(issue_number, label_name)
      options = githooks_defaults("/#{issue_number}/labels/#{label_name}")
      http_request('Delete', options)
    end

    def self.http_request(method, options={})
      get_uri = URI.encode(options[:defaults][:usable_uri])
      uri = URI.parse(get_uri)
      request = ::Net::HTTP.Delete.new(uri)
      request["Authorization"] = "token #{options[:defaults][:token]}"

      req_options = {
         use_ssl: uri.scheme == "https",
      } 
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request) 
      end
    end
  end
end