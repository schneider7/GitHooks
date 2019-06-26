# GitHooks
A Ruby on Rails engine that provides an endpoint for receiving GitHub webhooks and automatically updating labels as necessary.

## Purpose
This Rails engine allows the user to configure what should happen when a GitHub PR "review request" is submitted. The user can tell GitHooks which labels should be added or removed, and can define comments that should automatically happen when this event occurs. Distinct sets of actions can be defined when a reviewer puts "changes requested" vs. "approved".

Motivation was that it can be easy to forget to remove these tags, and this is a simple fix to ensure that the reviewer doesn't have to remember to do that. You can also look at [this link](https://developer.github.com/v3/activity/events/types) for more details on what you can do with the GitHub API, and how you could adapt this engine if you wanted to.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'git_hooks', git: 'https://github.com/schneider7/GitHooks'
```

And then execute:
```bash
$ bundle update
```
Add the following `mount` line to `routes.rb`, in your Rails app:

```ruby
# Rails.application.routes.draw do
  mount GitHooks::Engine, at: "/git_hooks"
```

Via the engine, this creates a `POST` route to handle the webhooks received at `/git_hooks`.

Now set up an outgoing webhook request from GitHub:

  - Navigate to the page for setting up webhooks within your repo: `(Repo) Settings > Webhooks > Add Webhook` 

  - Create a new webhook, select the option for the delivery to be in JSON form: `application/json`
  
  - For the URL, point it at https://yourapp.domain/git_hooks
  
  - For trigger options, select only "pull requests" and "pull request reviews". 
    
  If you're using this for an organization, you will probably want to create a ["machine account"](https://developer.github.com/v3/guides/managing-deploy-keys/) (i.e. a bot) with a name like "Company_Name Bot" that will have read/write/admin powers and then use it (and its access token) to interact with the API. This has the dual benefit of keeping the action going indefinitely (linking it to a specific person could cause issues if the person ever leaves the company) and also of clearly indicating in the GitHub user interface that the action was performed automatically by a bot.

## Authorization
  For authorization, you need a 40-digit OAuth access token specific to your GitHub account, rather than your username/password for authentication. You will want to [limit the scope of the access token when you request it from GitHub](https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/).

  **Give it repo scope.**
  
  ![Screencap of options](/pat-scope.png)

## Storing the Token: Config Variable
  If you're deploying to Heroku, you can simply create a config variable called `GITHUB_TOKEN` in the settings of your app, as shown below.

  More generally, you need to include the environment variable at the server level, however you deploy your app; in my case it's always Heroku.

  ![Defining GITHUB_TOKEN](/GITHUB_TOKEN.PNG)

## Configuration

In addition to using environment/config variable for the token, you'll also need to do some basic configuration of the app to suit your preferences. This part is pretty simple. To begin, you'll need to add a file called `git_hooks.rb` into your Rails App, in `/config/initializers`. Copy the following line of code, and populate it with the relevant information for your projects:

```ruby
GitHooks.active_repos = ["Repo 1", "Repo 2"]
# For example, ["SycamoreSchool", "SycamoreSchoolRails", "SycamoreCampus"]
# Obviously, it is acceptable if the array contains only one element.

# Allows you to customize action that occurs when PR review request is approved.
GitHooks.approved = {
  add: ["Funky Label", "Label 2!!!"],
  remove: ["Label to be removed"],
  comment: "" 
}

# Allows you to customize action that occurs when PR review request is sent as "changes requested".
GitHooks.rejected = {
  add: ["Changes Requested"],
  remove: []
  comment: "Changes are requested by the dev reviewer on this PR."
}

# NOTE: The arrays within the hashes CAN be empty; GitHooks properly handles empty arrays. 
# If you don't want the engine to leave comments on your PRs (it might get annoying), 
# Simply remove the comment: element from the hash and the engine will skip adding comments.
# Or, you can leave it as comment: "" (both options will simply skip over adding a comment).
```

If you have two repos with webhooks pointed at the same location (`.../git_hooks`) , and you make a change that triggers a hook, then GitHooks will know which repo the change came from (by parsing the webhook sent) and it will only modify that specific repo. This prevents, for example, a change on PR #3 of Repo_1 from editing the labels on PR #3 of Repo_2, or similar issues. **It also prevents any changes from occurring (i.e. being initiated by GitHooks) on repos that the user of this engine chooses not to consider "active"** (as defined in the above .rb file).

If you've mounted the engine properly, GitHooks will listen to GitHub webhooks whenever your Rails app is active, at the URL you specify.

## Notes

If you run into issues getting your app to run in production environment, you may have to precompile the assets with one of the following commands. Try them in order.
1) `rails db:migrate assets:precompile`
2) `RAILS_ENV=production rake db:migrate assets:precompile`

Someone more intelligent than me could probably explain why precompiling the assets sometimes fails, and why this helps.

If the logs show `Authentication error` or `401: Bad credentials` errors, [your environment variables might need to be refreshed](https://stackoverflow.com/questions/29289833/environment-variables-cached-in-rails-config). This happened to me during development.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
