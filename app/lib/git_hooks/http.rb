require 'net/http'

module GitHooks
  module Http
    
    def self.githooks_defaults(path)
      uri = ENV["BASE_URI"] + path
      {defaults: {uri: uri, token: ENV["GITHUB_TOKEN"]}}
    end
    
    def self.remove_label(repo_name, issue_number, label_name)
      options = githooks_defaults("/#{repo_name}/issues/#{issue_number}/labels/#{label_name}")
      http_request('Delete', options)
    end

    def self.add_label(repo_name, issue_number, labels)
      options = githooks_defaults("/#{repo_name}/issues/#{issue_number}/labels")
      http_request('Post', options.merge(params: { 'labels': labels }))
    end

    def self.get_labels(repo_name, issue_number)
      options = githooks_defaults("/#{repo_name}/issues/#{issue_number}/labels")
      http_request('Get', options)
    end

    def self.add_comment(repo_name, issue_number, body)
      options = githooks_defaults("/#{repo_name}/issues/#{issue_number}/comments")
      http_request('Post', options.merge(params: { 'body': body }))
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
      
      JSON.parse response.body
    end

  end
end