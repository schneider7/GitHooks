GitHooks::Engine.routes.draw do
  post '/pullrequests',   to: "pullrequests#label"
  get  '/help',           to: "pages#help"
end
