GitHooks::Engine.routes.draw do
  # get    '/help',      to: 'pages#help'
  post '/pullrequests',   to: "pullrequests#label"
end
