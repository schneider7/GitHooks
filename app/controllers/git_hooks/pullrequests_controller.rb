
module GitHooks
  class PullrequestsController < ApplicationController

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      # Get values from the parsed JSON that we'll need as arguments later on
      action_done      = request_payload["action"]
      number           = request_payload["pull_request"]["number"]
      repo_modified    = request_payload["pull_request"]["head"]["repo"]["name"]
      
      if GitHooks.active_repos.include?(repo_modified)
      
        if action_done == "submitted"
          submitted_status = request_payload["review"]["state"]
        end

        # If review request is approved on an active repo
        if action_done == "submitted" && submitted_status == "approved"
        
          labels_present = Http.get_labels(repo_modified, number)
          labels_present.map! { |h| h['name'] }

          if labels_present.include?("Dev Review")
            Http.remove_label(repo_modified, number, "Dev Review")
          end 
          
          Http.add_label(repo_modified, number, ["Dev Approved", "QA Review"])
        end
      
        # If review request is 'declined'
        if action_done == "submitted" && submitted_status == "changes_requested" 
          Http.remove_label(repo_modified, number, "Dev Review")
        end
      
        head :ok 

      else Rails.logger.error
         "GITHOOKS ERROR: That repo is not in your list of 
         active repos. Add it in the config file of your app. 
         See the README on GitHub for more info."

      end
    end
  end
end