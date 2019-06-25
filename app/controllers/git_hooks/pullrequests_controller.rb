
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
        ### You have alot of if-statments that could be combine together.
        ### Your checking "submitted" on most of your if-statements.
        ### And some should be combine to if-else statements
        if action_done == "submitted"
          submitted_status = request_payload["review"]["state"]
        end

        # If review request is approved on an active repo
        if action_done == "submitted" && submitted_status == "approved"
        
          labels_present = Http.get_labels(repo_modified, number)
          ### Your using single quotes here and double quotes everywhere else. I 
          ### would stick to one. The stand would be single quotes '' and double ""
          ### for interpolation
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

        ### This can probably be removed
        # Test action
        if action_done == "unlabeled" || action_done == "labeled"
          Http.add_label(repo_modified, number, ["WOOHOO"])
        end
      
        head :ok 

        ### I'm not sure that returning an error is the best thing right here.
        ### I would maybe lean more on just a message to stating this is not part
        ### of the active repos and return a :no_content status.
      else Rails.logger.error
         "GITHOOKS ERROR: That repo is not in your list of 
         active repos. Add it in the config file of your app. 
         See the README on GitHub for more info."

      end
    end
  end
end
