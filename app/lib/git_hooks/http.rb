require 'net/http'

module GitHooks
  module Http
    @base_uri = "https://api.github.com/repos/michael-schneider3/sample_app/issues"

    def self.githooks_defaults(path)
      uri = @base_uri + path
      {defaults: {uri: uri, token: ENV["GITHUB_TOKEN"]}}
    end
    
    def self.remove_label(issue_number, label_name)
      encoded_label_name = URI.encode(label_name)
      options = githooks_defaults("/#{issue_number}/labels/#{encoded_label_name}")
      http_request('Delete', options)
    end

    def self.http_request(method, options={})
      encoded_uri = URI.encode(options[:defaults][:uri])
      uri = URI.parse(encoded_uri)
      request = Net::HTTP::const_get(method).new(uri)
      request["Authorization"] = "token #{options[:defaults][:token]}"

      # req_options = { use_ssl: uri.scheme == "https" }

      response = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme == "https" }) do |http|
        http.request(request)
      end
    end
  end
end