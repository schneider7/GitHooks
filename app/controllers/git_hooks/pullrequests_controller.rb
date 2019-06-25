
module GitHooks
  class PullrequestsController < ApplicationController

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      # Get values from the parsed JSON that we'll need as arguments later on
      action_done      = request_payload['action']
      number           = request_payload['pull_request']['number']
      repo_modified    = request_payload['pull_request']['head']['repo']['name']
      
      if GitHooks.active_repos.include?(repo_modified) && action_done == 'submitted'
        labels_present = Http.get_labels(repo_modified, number)
        labels_present.map! { |h| h['name'] }
        
        dev_review = GitHooks.labels[:dev_review]
        dev_approved = GitHooks.labels[:dev_approved]
        qa_review = GtHooks.labels[:qa_review]
        
        submitted_status = request_payload['review']['state']

        if submitted_status == 'approved'
        
          Http.add_label(repo_modified, number, [dev_approved, qa_review])

          if labels_present.include?(dev_review)
            Http.remove_label(repo_modified, number, dev_review)
          end     

        elsif submitted_status == 'changes_requested' && labels_present.include?(dev_review)
          Http.remove_label(repo_modified, number, dev_review)
        end
             
        head :ok 

      else
        Rails.logger.debug 
          "GITHOOKS MESSAGE: #{repo_modified} is not in your list of 
          active repos. Add it in the config file of your app."

         head :no_content

      end
    end
  end
end
