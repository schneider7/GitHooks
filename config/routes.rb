GitHooks::Engine.routes.draw do
  get '/pullrequest',  to: "static_pages#index"
  post '/git_hooks', to: "pullrequest#label"
end
