
module GitHooks
  class PullrequestsController < ApplicationController

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done = request_payload["action"]
      number      = request_payload["pull_request"]["number"]
      status      = request_payload["review"]["state"]

      if action_done == "submitted" && status == "approved"
        Http.remove_label(number, "Dev Review")
        Http.add_label(number, ["Dev Approved"])
        Http.add_label(number, ["QA Review"])        
      end

      if action_done == "submitted" && status == "changes_requested"
        Http.remove_label(number, "Dev Review")
      end
      
      head :ok 
    end
  end
end