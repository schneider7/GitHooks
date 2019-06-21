require 'net/http'

module GitHooks
  module Http
    
    def self.githooks_defaults(path)
      uri = ENV["BASE_URI"] + path
      {defaults: {uri: uri, token: ENV["GITHUB_TOKEN"]}}
    end
    
    def self.remove_label(issue_number, label_name)
      options = githooks_defaults("/#{issue_number}/labels/#{label_name}")
      http_request('Delete', options)
    end

    def self.add_label(issue_number, labels) #takes an array as an argument
      options = githooks_defaults("/#{issue_number}/labels")
      http_request('Post', options.merge(params: { 'labels': labels }))
    end

    def self.http_request(method, options={})
      encoded_uri = URI.encode(options[:defaults][:uri])
      uri = URI.parse(encoded_uri)
      request = Net::HTTP::const_get(method).new(uri)
      request["Authorization"] = "token #{options[:defaults][:token]}"

      request.body = JSON.dump(options[:params]) unless options[:params].nil?

      response = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme == "https" }) do |http|
        http.request(request)
      end
    end
  end
end