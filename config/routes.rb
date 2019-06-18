GitHooks::Engine.routes.draw do
  post '/pullrequests',   to: "pullrequests#label"
end
