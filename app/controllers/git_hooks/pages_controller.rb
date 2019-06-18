module GitHooks
  class PagesController < ::GitHooks::ApplicationController
    def help
      render 'help'
    end
  end
end
