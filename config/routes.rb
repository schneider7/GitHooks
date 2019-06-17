GitHooks::Engine.routes.draw do
  get    '/help',      to: 'pages#help'
  post '/git_hooks',   to: "pullrequests#label"
end
