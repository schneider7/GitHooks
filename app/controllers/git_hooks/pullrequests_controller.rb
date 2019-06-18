module GitHooks
  class PullrequestsController < ::GitHooks::ApplicationController
    
    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done = request_payload["action"]
      issue_number = request_payload["pull_request"]["number"]

      if action_done == "labeled"
        HTTPable.remove_label(issue_number, 'QA Review')
        HTTPable.remove_label(issue_number, 'Dev Review')
      end
      
      status 200 
    end
  end
end