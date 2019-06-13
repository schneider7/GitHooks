module GitHooks
  class PullrequestController < ApplicationController
  
    client = Octokit::Client.new(GitHooks.access_token)

    def destroy
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done = request_payload["action"]
      issue_number = request_payload["pull_request"]["number"]

      if action_done == "submitted"
        client.remove_label(GitHooks.base_url, issue_number, 'QA Review')
        client.remove_label(GitHooks.base_url, issue_number, 'Dev Review')
      end
      
      status 200 
    end
  end
end