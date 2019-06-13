Rails.application.routes.draw do
  mount GitHooks::Engine => "/git_hooks"
end
