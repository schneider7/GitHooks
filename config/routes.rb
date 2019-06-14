GitHooks::Engine.routes.draw do
  post '/git_hooks/pullrequest', to: "pullrequest#label"
end
