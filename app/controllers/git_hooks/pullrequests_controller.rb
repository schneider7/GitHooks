
module GitHooks
  class PullrequestsController < ApplicationController

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      # Get values from the parsed JSON that we'll need as arguments later on
      repo_modified    = request_payload["pull_request"]["head"]["repo"]["name"]
      action_done      = request_payload["action"]
      number           = request_payload["pull_request"]["number"]

      labels_present = Http.get_labels(repo_modified, number)
      labels_present.map! { |h| h['name'] }
      
      if GitHooks.active_repos.include?(repo_modified)
      
        if action_done == "submitted"
          submitted_status = request_payload["review"]["state"]
        end

        # If review request is approved on an active repo
        if action_done == "submitted" && submitted_status == "approved"
        
          if labels_present.include?("Dev Review")
            Http.remove_label(repo_modified, number, "Dev Review")
          end 
          
          Http.add_label(repo_modified, number, ["Dev Approved"]) 
          Http.add_label(repo_modified, number, ["QA Review"])        
        end
      
        # If review request is 'declined'
        if action_done == "submitted" && submitted_status == "changes_requested" 
          Http.remove_label(repo_modified, number, "Dev Review")
        end
      
        # Test action
        if action_done == "labeled" || action_done == "unlabeled"
          labels_present = Http.get_labels(repo_modified, number)
          Http.add_comment(repo_modified, number, labels_present)
          Http.add_label(repo_modified, number, ["WOOHOO"])
        end

        head :ok 

      else Rails.logger.error "That repo is not in your list of active repos.
        Add it in the config file of your app. See 
        the README on GitHub for more info."

      end
    end
  end
end