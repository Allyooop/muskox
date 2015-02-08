## Set up Devise

Devise is a very popular Gem that quickly provides any Rails app with the parts needed to handle user sign-ins, registration and all manner of authentication.

Let's put it into our app. Crack open the Gemfile and add the following gem anywhere you like:

```ruby
gem 'devise'
```

Whenever you update your gemfile you need to run bundle install. Do that now:

```bash
# update gemfile
bundle install
```

The next thing to do is install the devise "engine". A Rails Engine is a modular app that sits within Rails and provides extended functionality like authentication, content management abilities etc.

To install devise run the following command:

```bash
rails generate devise:install
```

This will create a devise.rb initializer file as well as a language .yml file.

```bash
create  config/initializers/devise.rb                      
create  config/locales/devise.en.yml     
```

We won't be touching these files so don't worry about them for now.

There is a little bit of manual setup required for Devise and it outputs the steps needed in the command-line. Let's go through them and complete them all!

1. define default url option in environment file

To achive this, open your ```/config/environments/development.rb``` file add add the following line:

```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }                                                       
```

What we are doing here is setting the default URL for our emailing system and the port to send email out from for deployment.

2. have a root url in the routes.rb file

We have already done this so we are good to continue

3. Have "flash" messages included in the default layout erb file

We haven't added these, so let's do so quickly.

In our ```/app/views/layouts/application.html.erb``` file add the following two snippets just above the **yield** tag like so:

```erb
   <p class="notice"><%= notice %></p>                         
   <p class="alert"><%= alert %></p> 
 
  <div id="main">
    <%= yield %>
  </div>
```

This just adds two paragraphs styled by Devise that both contain any notices or alerts that Devise may need to send such as an incorrect password or an error of somekind.

4. only relates to the deployment platform Heroku so for now we'll not doing anything with it

5. Copy devise views for customization

We do want to do this. This takes the Devise views from just inside the Devise engine and into our app which makes it easy to customize the code.

In the command-line run:

```bash
rails g devise:views
```
This will create a folder within your views directory which contains the views. The folder is called **devise** stored within the ~/app/views/ folder. There are a lot of sub-folders and within them **.erb** files

```
app/views/devise/shared/                                         
app/views/devise/shared/_links.html.erb                         
app/views/devise/confirmations/                                  
app/views/devise/confirmations/new.html.erb                     
app/views/devise/passwords/                                      
app/views/devise/passwords/edit.html.erb                        
app/views/devise/passwords/new.html.erb                         
app/views/devise/registrations/                                  
app/views/devise/registrations/edit.html.erb                    
app/views/devise/registrations/new.html.erb                     
app/views/devise/sessions/                                       
app/views/devise/sessions/new.html.erb                          
app/views/devise/unlocks/                                        
app/views/devise/unlocks/new.html.erb                           
app/views/devise/mailer/ 
app/views/devise/mailer/confirmation_instructions.html.erb      
app/views/devise/mailer/reset_password_instructions.html.erb    
app/views/devise/mailer/unlock_instructions.html.erb 
```

That is a whole ton of files. Essentially they provide the forms for users to sign up, in and out of your app. We'll cover styling Devise later, for now let's finish off installing Devise before moving onto creating a blog-like article model.

Our final thing we need to do to install Devise is run the following command:

```bash
rails generate devise
```

This will create a database migration, include some devise routes into our routes.rb file as well as inject into our user.rb model some devise symbols.

For now, we'll now cover too much of this. Run another migration to update your database:

```bash
rake db:migrated
```

But you now have a fully functioning user sign in system. Awesome!
