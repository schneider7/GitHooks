# GitHooks
A Ruby on Rails engine that provides an endpoint for receiving GitHub webhooks and automatically updating labels as necessary.

Author: [Michael Schneider](http://www.michaelschneider.me)

## Usage
This RoR engine is specifically set up to remove `Dev Review` label and add `Dev Approved` on a GitHub pull request, once review has actually been completed. If changes are requested, `Dev Review` is removed. 

Motivation was that it can be easy to forget to remove these tags, and this is a simple fix to ensure that the reviewer doesn't have to remember to do that. This is only one specific usage; see [this link](https://developer.github.com/v3/activity/events/types) for more details on what you can do with the GitHub API.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'git_hooks', git: 'https://github.com/michael-schneider3/GitHooks'
```

And then execute:
```bash
$ bundle update
```

(You may also need to run `rm Gemfile.lock` first) 


Add the following `mount` line to `routes.rb`, in your Rails app:

```ruby
# Rails.application.routes.draw do
  mount GitHooks::Engine, at: "/git_hooks"
```

This creates a `POST` route to handle the webhooks at the specified point, e.g. `/git_hooks/pullrequests`.

Now set up an outgoing webhook request from GitHub:

  -Navigate to the page for setting up webhooks within your repo: `(Repo) Settings > Webhooks > Add Webhook` 

  -Create a new webhook, select the option for the delivery to be in JSON form: `application/json`
  
  -Following my example, for the URL, point it at https://yourapp.domain/git_hooks/pullrequests
  
  and for trigger options, select "pull request", and "pull request reviews".

  
  Here, you only need a 40-digit OAuth access token specific to your GitHub repo, rather than your username/password for authentication. You can optionally [limit the scope of the access token when you request it](https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/). 
  
  Give it repo scope.
  
  ![Screencap of options](/pat-scope.png)

  If you'll be committing to GitHub, you'll want to store your `token` in a `.yml` file, as follows:
    Under `/config`, create a file named `env.yml` and populate it with info specific to your repo:



  ```ruby 
    production:
      GITHUB_TOKEN: "your_40-digit_token"
      BASE_URL: "https://api.github.com/repos/FILL_IN_USER_NAME/FILL_IN_REPO_NAME/issues"

    development:
      GITHUB_TOKEN: "your_40-digit_token"
      BASE_URL: "https://api.github.com/repos/FILL_IN_USER_NAME/FILL_IN_REPO_NAME/issues"
  ```
  This will allow you to access the 40-digit string with ENV["GITHUB_TOKEN"], which is a necessary step to "hide" the token from GitHub.

  Now, add the following line to `.gitignore`:
  ```ruby
      /config/env.yml
  ```
  As you may know, you're not allowed to commit a change to GitHub if it includes a valid OAuth token; GitHub will automatically revoke the token if they see this happen. This step prevents GitHub from pushing the file that includes the token, avoiding this issue.

  If you're deploying to Heroku, you can create a config variable called GITHUB_TOKEN in the settings of your app, and a config variable called BASE_URL with the information from above.

  More generally, you need to include the environment variables at the server level, however your deploy your app. If you're using this engine, odds are you will know what this means.


If you've mounted the engine properly, GitHooks will listen to GitHub webhooks whenever your Rails app is active, at the URL you specify.

  Note: If the logs show `Authentication error` or `401: Bad credentials` errors, [your environment variables might need to be refreshed](https://stackoverflow.com/questions/29289833/environment-variables-cached-in-rails-config). This happened to me several times during development.


## Notes

If you run into issues getting the app to run in production environment, you may have to precompile the assets with one of the following commands. Try them in order.
1) `rails db:migrate assets:precompile`
2) `RAILS_ENV=production rake db:migrate assets:precompile`

Someone more intelligent than me could probably explain why precompiling the assets sometimes fails.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
