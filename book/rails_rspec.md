# Installing RSpec and updating our Gemfile

## Updating your Gemfile

Let's do two things to our gemfile. First, let's add the test framework RSpec. RSpec is the most popular testing framework for Rails so let's use that.

Because this book isn't about testing, we will be pretty light on the testing angle but to make sure we have something we'll also install an automatic testing framework which helps us build something so if you build additional functionality, you'll know when you've broken your app.

Add to your gemfile the following things:

```ruby
# Add additional testing gems to project
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'zapata'
end
```

Awesome. The ```group``` keyword allocates the following things into specific groups designated in your rails environments, with the defaults being :development, :test and :production.

> further explanation

Now, lets remove the rails-coffeescript gem. We are going to do this just so that we create plain old JavaScript instead of coffeescript files. JavaScript is easier for developers in the early stage of their career and I personally prefer it.

Locate your Gemfile again and **remove** the following:

```ruby
# remove coffescript gem from project
gem 'coffee-rails', '~> 4.0.0'
```
Everytime you update your gemfile for your Rails project you should run bundle install. From the project directory run:

```bash
bundle install
```

After that we just need to initalize our RSpec testing framework. Run the following command:

```bash
rails generate rspec:install
```

That should run a Rails command to create four things. That is all for now, let's get back to setting up our Rails app.
