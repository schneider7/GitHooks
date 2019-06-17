GitHooks::Engine.routes.draw do
  get '/pullrequest',  to: "pages#index"
  post '/git_hooks',   to: "pullrequests#label"
end
