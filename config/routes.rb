GitHooks::Engine.routes.draw do
  post '/git_hooks/pullrequest', to: "githooks/pullrequest#label"
end
