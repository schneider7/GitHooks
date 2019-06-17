GitHooks::Engine.routes.draw do
  get '/git_hooks',  to: "static_pages#git_hooks"
  post '/git_hooks', to: "pullrequest#label"
end
