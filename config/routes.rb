GitHooks::Engine.routes.draw do
  # get    '/help',      to: 'pages#help'
  post '/git_hooks/pullrequests',   to: "pullrequests#label"
end
