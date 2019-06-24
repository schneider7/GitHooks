GitHooks::Engine.routes.draw do
  post '/', to: "pullrequests#label"
end
