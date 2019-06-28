require "git_hooks/engine"

module GitHooks
  mattr_accessor :active_repos 
  mattr_accessor :approved
  mattr_accessor :rejected
  mattr_accessor :review
end
