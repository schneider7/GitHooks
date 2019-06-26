
module GitHooks
  class PullrequestsController < ApplicationController

    def label
      request.body.rewind
      request_payload = JSON.parse(request.body.read)
      
      action_done      = request_payload['action']
      number           = request_payload['pull_request']['number']
      repo_modified    = request_payload['pull_request']['head']['repo']['name']
      
      if GitHooks.active_repos.include?(repo_modified) && action_done == 'submitted'
        labels_present = Http.get_labels(repo_modified, number)
        labels_present.map! { |h| h['name'] }
        submitted_status = request_payload['review']['state']

        if submitted_status == 'approved'
          
          unless GitHooks.approved[:add].blank?
            Http.add_label(repo_modified, number, GitHooks.approved[:add])
          end
  
          GitHooks.approved[:remove].each do |label| 
            if labels_present.include?(label)
              Http.remove_label(repo_modified, number, label)
            end
          end

          unless GitHooks.approved[:comment].blank?
            Http.add_comment(repo_modified, number, GitHooks.approved[:comment])
          end
          
        elsif submitted_status == 'changes_requested'
          
          unless GitHooks.rejected[:add].blank?
            Http.add_label(repo_modified, number, GitHooks.rejected[:add])
          end

          GitHooks.rejected[:remove].each do |label|
            if labels_present.include?(label)
              Http.remove_label(repo_modified, number, label)
            end
          end

          unless GitHooks.rejected[:comment].blank?
            Http.add_comment(repo_modified, number, GitHooks.rejected[:comment])
          end

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
