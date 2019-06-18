module GitHooks
  class PagesController < ::GitHooks::ApplicationController
    def help
      layout 'help'
    end
  end
end
