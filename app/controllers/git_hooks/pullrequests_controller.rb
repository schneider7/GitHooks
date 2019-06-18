module GitHooks
  class PullrequestsController < ::GitHooks::ApplicationController
    
    require 'octokit'
    client = Octokit::Client.new(GithubWebhooks.access_token)

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done = request_payload["action"]
      issue_number = request_payload["pull_request"]["number"]

      if action_done == "submitted"
        client.remove_label('https://github.com/michael-schneider3/sample_app', issue_number, 'QA Review')
        client.remove_label('https://github.com/michael-schneider3/sample_app', issue_number, 'Dev Review')
      end
      
status 200
    end
  end
end