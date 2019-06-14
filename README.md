# GitHooks
Ruby on Rails engine for receiving GitHub webhooks and automatically updating labels as necessary.

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
$ bundle
```

Add the following `mount` command to your `routes.rb`, which is located in /config:
```
Rails.application.routes.draw do
  mount GitHooks::Engine, at: "/git_hooks"
```

This creates a `POST` route to handle the webhooks at the specified point.

Now set up an outgoing webhook request from GitHub:

  Navigate to the page for setting up webhooks within your repo.

  Create a new webhook, select the option for the delivery to be in JSON form: `application/json`
  
  For the URL, point it at https://yourapp.domain/git_hooks
  
  and for trigger options, select "pull request", and "pull request reviews".

  Now create `config/initializers/git_hooks.rb` ***in your Rails App** and populate the API credentials and set the default path to your repo's, as below.

  ```
  GitHooks.access_token = "YOUR_40_DIGIT_ACCESS_TOKEN"
  GitHooks.base_url = "https://github.com/USER_NAME/REPO_NAME"
  ```

  Here, you only need a 40-digit OAuth access token specific to your GitHub repo, rather than your username/password for authentication. If you want (and this is worthwhile), you can optionally [limit the scope of the access token when you request it](https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/). 

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
