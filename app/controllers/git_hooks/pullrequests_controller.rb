module GitHooks
  class PullrequestsController < ApplicationController
  
    def self.label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done = request_payload["action"]
      issue_number = request_payload["pull_request"]["number"]

      if action_done == "labeled"
        HTTPable.remove_label(issue_number, 'duplicate')
        HTTPable.remove_label(issue_number, 'bug')
      end
      
      head :ok 
    end
  end
end