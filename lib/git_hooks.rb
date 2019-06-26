require "git_hooks/engine"

module GitHooks
  mattr_accessor :active_repos 
  mattr_accessor :add_when_approved
  mattr_accessor :rmv_when_approved
  mattr_accessor :add_when_rejected
  mattr_accessor :rmv_when_rejected

  mattr_accessor :approved
  mattr_accessor :rejected
end
