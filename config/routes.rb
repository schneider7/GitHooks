GitHooks::Engine.routes.draw do
  resources :pullrequest, only: :destroy, constraints: {format: 'json'}
end
