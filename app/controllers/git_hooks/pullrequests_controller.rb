
module GitHooks
  class PullrequestsController < ApplicationController

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done = request_payload["action"]
      number = request_payload["pull_request"]["number"]

      if action_done == "labeled"
        Http.remove_label(number, 'QA Review')
        Http.remove_label(number, 'Dev Review')
      end
      
      head :ok 
    end
  end
end