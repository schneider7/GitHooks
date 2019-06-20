# GitHooks
Ruby on Rails engine that providese an endpoint for receiving GitHub webhooks and automatically updating labels as necessary.

Author: [Michael Schneider](http://www.michaelschneider.me)

## Usage
This RoR engine is specifically set up to remove "Review" labels on a GitHub pull request, once review has actually been completed. Motivation was that it can be easy to forget to remove these tags, and this is a simple fix to ensure that the reviewer doesn't have to remember to do that. This is only one specific 
usage; see the docs for Octokit to see the full scope of what you can do with the Github API.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'git_hooks', git: 'https://github.com/michael-schneider3/GitHooks'
```

And then execute:
```bash
$ bundle update
```

(You may need to execute `rm Gemfile.lock` first) 


Add the following `mount` command to `routes.rb`, in your Rails app:

```ruby
# Rails.application.routes.draw do
  mount GitHooks::Engine, at: "/git_hooks"
```

This creates a `POST` route to handle the webhooks at the specified point, e.g. `/git_hooks/pullrequests`.

Now set up an outgoing webhook request from GitHub:

  Navigate to the page for setting up webhooks within your repo.

  Create a new webhook, select the option for the delivery to be in JSON form: `application/json`
  
  For the URL, point it at https://yourapp.domain/git_hooks/pullrequests
  
  and for trigger options, select "pull request", and "pull request reviews".

  Now create `config/initializers/git_hooks.rb` ***in your Rails App** and populate the API credentials and set the default path to your repo's, as below.

  ```
  GitHooks.access_token = "YOUR_40_DIGIT_ACCESS_TOKEN"
  GitHooks.base_url = "https://github.com/USER_NAME/REPO_NAME"
  ```

  Here, you only need a 40-digit OAuth access token specific to your GitHub repo, rather than your username/password for authentication. If you want (and this is worthwhile), you can optionally [limit the scope of the access token when you request it](https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/). 

  If you'll be committing to GitHub, you'll need to store your `token` in a `.yml` file, as follows:
    Under `/config`, create a file named `env.yml` and populate it like this:

    ```ruby 
    production:
      GITHUB_TOKEN: "your_40-digit_token"

    development:
      GITHUB_TOKEN: "your_40-digit_token"
    ```
    This will allow you to access the 40-digit string with ENV["GITHUB_TOKEN"], which is necessary to "hide" the token from GitHub.

    Now, add the following line to `.gitignore`:
      ```ruby
      /config/env.yml
      ```
    You're not allowed to commit a change to GitHub if it includes a valid OAuth token; GitHub will automatically revoke the token if they see this happen. This step prevents GitHub from pushing the file that includes the token, avoiding this issue.

    If you're deploying to Heroku, you can create a config variable called GITHUB_TOKEN in the settings of your app.

  Note: If the logs show `Authentication error`s or `401: Bad credentials` errors, [your environment variables might need to be refreshed](https://stackoverflow.com/questions/29289833/environment-variables-cached-in-rails-config). This happened to me several times during development.


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
