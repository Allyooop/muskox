# Building a CMS with Rails

In this book we will build a minimal CMS with Rails. 

We will create a dashboard that our users can use to create articles and update other important information which will update information available to our users.

This CMS will not be a traditional CMS where they can directly edit and update the fontend of their site. The idea is that you let the content creators create the content and leave the design and frontend alone.

We will let the users set certain features, like the featured service or article, but the design, the "look and feel" will be not be something we will let them edit.

## Install & Configure MySQL

### Install steps

### Configuration

First you need to sign in as your root user

```sql
mysql -u root -p
```
This loads up the interactive MySQL environment or shell.

Stay in the shell until prompted to leave.

Running the `mysql -u root -p` command will prompt you for your password, set when you first installed MySQL.

Insert that right now.

> **ProTip** - remember, you don't need to run the ```/* I AM A COMMENT */``` bit of my code. That is there for futher explanation. The rest however, is good to run.

#### Create your db user

Right, still in the MySQL shell, create an app specific user. To do this, enter:

```sql
CREATE USER 'rails'@'localhost' IDENTIFIED BY 'secure-password';
```
This tells the database to create a user (called rails) who can access the MySQL database locally (same computer the db is located) who has, or is "IDENTIFIED" by, the password within the '' which in our case is the totally secure **secure-password**.

> Feel free to change the values of rails and secure-password - ensuring that you note them down and use them throughout of course!. The actual words secure-password is not exactly secure!
> Insert cartoon about having a secure password

#### Create your app's db

The next thing to do is create our application database. To do this, still within your MySQL shell, run:

```sql
CREATE DATABASE muskox_db;
```
As you can likely tell, we've told MySQL to create a database called muskox_db.

> Don't forget to add the semi-colon to the end of your command! In SQL this is the indicator to execute what has been written.

#### Give the user/app the ability to edit the newly created db

The next thing we need to do is give the user account we created for our Rails app the ability to edit the new MySQL database. To do this we run:

```sql
/* */
GRANT ALL PRIVILEGES ON muskox_db.* TO 'rails'@'localhost' IDENTIFIED BY 'secure-password';
```

This command gives the new user we created called rails the ability to edit our muskox_db. The parts of the command break down to:

* ```GRANT ALL PRIVILEGES ON``` = give the ability edit the following db
* ```muskox_db.*``` [or whatever db you called it!] = the database and tables the command to allow a user to edit relates to
* ```TO 'rails'@'localhost'``` = user the command relates to
* ```IDENTIFIED BY 'secure-password'``` = as long as they have the password of secure-password

So altogether, that command gives the user rails the ability to edit the database muskox_db and all the data and tables within it as long as it is using secure-password as the password.

We are nearly finished but the last thing we need to do is reload all the privledges. To do this admin step we run:

```sql
FLUSH PRIVILEGES;
```
> What MySQL does is just work with the users set in its memory. When you loaded MySQL you hadn't created the new user yet - and so it doesn't have your new user in its memory. The flush command is just a refresh for MySQL. It forces it to reload its memory from its disk. Think of it as a way of ensuring 100% MySQL is working with the new user in its memory by making it look up how many users it has and what they are allowed to do.

Fantastic, we've gone into our MySQL command shell. Created a new user with a password, a new database and give the user the ability to edit that database.

To exit the MySQL shell run:

```sql
EXIT;
```
We have a lovely new user and database set up for our rails project. Time to create that and put that database to use.

## Create your Rails Project

Working from the directory you want to build your app, in your console, run the following command:

```bash
rails new muskox -d mysql -T
```

The `rails new` command tells the rails gem to scaffold out the initial Rails template and the word after new is what it will call the project. In our case, we have called is muskox.

> We are calling our CMS muskox. A [muskox](Codio.com) is a buffalo/sheep thing that has survived since the last Ice Age, a bit like the need for CMSes

The "flags" we raised are `-d mysql` and `-T` which stand for:

* `-d` = change database
* `-T` = remove default test framework

We designated mysql as the database we wanted to use with the `-d` flag and we did that by writing it after.

make sure you `cd muskox` afterwards to move into the directory. If you don't the following commands throughout the chapter won't work.

Because we removed the default test framework we also have to plug one back in. Let's make sure we have a test framework set up. We'll also remove a Gem from our gemfile to make things as human readable as possible.

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

## Setting up your Rails DB

Our next step is to ensure our database is configured correctly with Rails. Rails is pretty awesome but it is not a mind-reader. We'll have to make sure we get our MySQL database connected and talking to each other.

Inside your rails project, open up the **database.yml** file located in the **/config** folder.

Opening that up, you will see something like this:

```yaml
# ~/config/database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: root
  password:
  host: localhost

development:
  <<: *default
  database: muskox_developments
```
This is a YAML file (.yml and .yaml are the common file names). YAML stands for YAML Ain't Markup Language. If that self-referential statement sounds weird, it's because it used to be called "Yet Another Markup Language" but does little markup in the sense of HTML and the creators wanted to ensure people knew it wasn't a language like HTML. Still confused? Don't worry about it. To find out more about YAML, see the [YAML website](http://www.yaml.org/).

YAML is a data syntax which has a **key** and a corresponding **value** next to it. Key-value pairs are a really common concept in computer science so it worth getting.

#### Key-value

A key-value relationship is very simple but important to get right. If you have ever looked at a history book or an excel chart you would have used one.

Taking a chart as our example, lets say our key is **"revenue made in a certain year"** and our value how much we made. Each year we update our key-value pair to create a chart. Here is our potential YAML file with the key first and the value second:

```yaml
revenue_in_2014: 10
revenue_in_2013: 20
revenue_in_2012: 25
```
Besides needing a new job, we could turn it into a chart that looked like this:

> INSERT CHART IMAGE

As you have likely seen before, that chart is made up of a key, our revenue in a particular year, and a value, the amount we made.

And that is all a key-value pair means. 

Hopefully that has helped a little bit.

> Another way of thinking about keys and values is like a spreadsheet with lots of cells. In one row you have things like: name, job, city. These are the keys. In a row below you have things like: Andrew, Developer, Sheffield. So, in one row you have a key and the other a value with each value belonging to a key.

#### Back to our database.yml file

So, in terms of our database.yml file we need to update the key value pairs with information that relates to our database we created.

The default keys are inherited by the "development", "test" and "production" sections. That is, you define general keys and values at the top and the rest of the sections use this syntax ```<<: *default``` to use all those keys and values without having to repeat them.

So, we need to update your info. Write the following:

```yaml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: rails
  password: secure-password
  host: localhost

development:
  <<: *default
  database: muskox_db
```
We have updated the default values in the default and development areas with our MySQL username, password, dbname and password.

> If you chose your own MySQL db name etc. make sure this file reflects that.
> On, and yes. Just putting your password into a file like this is **NOT** secure. When we come to putting this product online we'll do something a lot better but for now we'll settle for this.

Right, let's check that everything is connected correctly. In your terminal run the command to start the default rails server:

```bash
# you can also run "rails s" with s being shorthand for server
rails server
```

This should boot up your WEBrick server on the second line indicating which URL the rails app is working on:

```bash
=> Rails 4.1.8 application starting in development on http://0.0.0.0:3000
```

Visit that address in your browser and if you have everything set up right you'll see the traditional new rails app homepage

> INSERT PIC

If that isn't what you see, try and troubleshoot with the info provided. Some of your issues may be:

* Have you entered the right URL?
* Is your MySQL server running?
* Have you entered ALL of the details correctly?
* Did you run Rails S, rawhat is that saying?
* Are you in the Rails directory when you ran that command?

Hopefully everything is working smoothly. Right, time to do some building. In the next chapter we'll create our homepage

## Create your homepage

In this chapter we are going to create our basic homepage. We are going to use the default rails generators to do use. We will then add our first "views" so that we can see this site.

We will also touch on Rails routing to make sure that when someone goes to the route "/" they see the homepage we have designed rather than the basic rails app homepage.

Throughout this chapter we will also add some styles to our app so it doesn't look terrible. We will use SASS which is a developer friendly CSS preprocessor (essentially CSS with developer/designer-focused shortcuts ). 

#### generate our first controller

Let's create our first meaningful additon to the app!

> You'll be happy to know, as far as configuration, that is most of it for the book... apart from deployment!

We are going to heavily leverage the default Rails generators. You can generate a lot from the command line. Each of the available generators require certain things to be added.

Essentially the pattern you follow is ```rails g``` (g is shorthand for generate) followed by the resource you want to generate, the name of the resource and then any optional things you want the generated resource to contain (like a page called index or a database column of people's names etc.)

Following this pattern, let's create a "controller" named pages with a webpage called index. To do so, run the following command:

```bash
rails g controller Pages index
```
This is will create a lot of files. Before we get into what it created, let's look at what we asked Rails to generate.

As mentioned we ran the ```rails g``` command. We followed that with what resource we wanted to create (a controller) the name of our controller ```Pages```, to which we added a sub-resource called ```index``` (which in terms of creating a controller, is a method called index).

So, when we ran that command we created ALOT of files. They are all really simple BUT, it can be a little bit intimidating to see them all at once when you are learning Rails. Here is what it looks like:


```bash
 create  app/controllers/pages_controller.rb                    
       route  get 'pages/index'                                      
      invoke  erb                                                    
      create    app/views/pages                                      
      create    app/views/pages/index.html.erb                       
      invoke  rspec                                                  
      create    spec/controllers/pages_controller_spec.rb            
      create    spec/views/pages                                     
      create    spec/views/pages/index.html.erb_spec.rb              
      invoke  helper                                                 
      create    app/helpers/pages_helper.rb                          
      invoke    rspec                                                
      create      spec/helpers/pages_helper_spec.rb                  
      invoke  assets                                                 
      invoke    js                                                   
      create      app/assets/javascripts/pages.js                    
      invoke    scss                                                 
      create      app/assets/stylesheets/pages.css.scss  
```

Lets go through what's happening. 

1. Rails creates a file called pages_controller.rb in your /app/controllers/ folder
2. Rails updates your routes file with one that responds to 'pages/index'
3. Rails uses the invoke erb command to call the erb templating resource to do some work
4. the erb resource creates a folder called /pages/ inside the /app/views/ folder and within that creates an erb file called index.html.erb
5. the rspec gem is then called on to do some work itself
6. it creates a spec or group of tests for your controller and mirrors what erb created with tests for everything
7. the helper resource is called
8. the helper resource creates a file
9. the rspec gem is invoked again
10. rspec creates a test file for the helper file
11. the asset resource (gems etc.) are asked to do some work
12. the JavaScript part of your asset resources is called first
13. the JavaScript asset resource creates a pages.js file
14. your Scss asset resource is the called
15. your Scss resource creates a pages.css.scss file to let you style your page views

Well, that was a lot of info. Feel free to explore what was created in those files. Google everything and anything you don't understand or interests you. In our next section we'll take a look at our route file.

#### update our root routes

In this section we'll update our routes file and hopefully get a better sense of how our rails app is wired together.

Locate your routes.rb file which should be found here ```~/muskox/config/routes.rb```.

There are a lot of comments in this file. Feel free to keep them and read them, but at the moment the most important information is located between ```Rails.application.routes.draw do end```. Namely our custom pages controller's index page.

So, at this stage we have one single route we added ourselves. 

> If you ever need to know what routes are available to your webapp, just run ```rake routes``` in your terminal. Right now, ours looks like this:
```bash              
Prefix Verb URI Pattern            Controller#Action            
pages_index GET  /pages/index(.:format) pages#index  
```

When people go to our webapp with the URL of ```localhost:3000/pages/index``` they will get our newly created index.html.erb file served by our pages_controller.rb controller.

So, the route is defined by using the HTTP verb "get" with the "URI pattern" of '/pages/index' which Rails matches to our controller named pages and method called index.

That method, called index, automatically looks for a .html.erb file called index inside the views folder. Naturally you can override this, but as Rails does all the wiring automatically, it is best not to.

Sometimes it is also easier to understand something with a diagram, so here is the process Rails goes through to render a webapge:

> INSERT IMAGE

Let's have a look at everything working. Fire up your server by running:

```bash
# s is shorthand for server
rails s
```

you should see the following webpage:

> INSERT IMAGE (rails_app_screenshot_basic_route.png)

Not exactly the most beautiful thing in the world but we are getting somewhere.

Now, we don't just want this page to be something people have to find through the pages URL, we want it to be our homepage.

In Rails terminology, we wanted to make it our "root". The explanation of how to do this is in the comments of the routes.rb file. Can you work out how to add it?

Don't worry if you couldn't get it right. What you needed to add below ```get 'pages/index'``` was:

```ruby
root 'pages#index'
```

So, to set something as root we must offer inside quotes our choice of controller and "action" or method after the word root. In our case we only have one controller and one action/method and that is our pages controller and index method.

Add that line in now.

With the Rails server still running - if not, run ```rails s``` again - go to your root url ```localhost:3000``` and you should see our rather boring generated page again, but this time at the root url. Success!

> Now might be a good time to rattle along your own track and create another controller or extend the current one?. Can you set up an about page?

#### update corresponding view file

Lets add a touch of branding to our app so it doesn't look completely sparse. I won't go through too much here as we are just adding a baseline look and we will do more here later.

##### add basic navbar

Right, lets add a very basic navbar to our basic layout. To do this we will create a partial called ```_navbar.html.erb```.

It is convention in Ruby and Rails that any partial, an element that is injected into another to make a whole template, is named with an underscore first. This way, when a developer, or yourself, looks at a file with an underscore they know that they are the small modules that make up a larger whole somewhere else.

Right, create our navbar partial in a new views directory. Create a new directory called ```shared``` where we'll drop any partials that can be shared across views files. 

Your file should be available here:

```~/app/views/shared/```

In that new directory create a file called ```_navbar.html.erb```. Fill it with the basic HTML below:

```html
<!-- put the navbar in /app/views/shared/application.html.erb -->
  <nav>
    <div class="nav-container">
     <ul>
      <li><a href="#">Muskox</a></li>
    </ul>
    </div>
  </nav>
```

Working in the same directory, we need to update our ```application.html.erb``` file to include the partial.

In ```/app/views/layouts/application.html.erb``` add the following just above the ```<%= yield %>:

```rails
<%= render "shared/navbar" %>
```

> ## How do ERB!
> to find out more about rendering and layouts, a great resource is [the Rails Docs that cover this subject](http://guides.rubyonrails.org/layouts_and_rendering.html)

Let's add some basic Scss.

First rename ```application.css``` to ```application.css.scss```. This ensures we are using scss.

Next, rename ```pages.css.scss``` to ```_variables.css.scss```

This file will be where we declare our global variables like colors and fonts.

Inside this file, delete the comments and content and replace it with:

```sass
$brand-font: Arial, Helvetica, sans-serif;
$brand-color: #E53935;
$brand-grey: #F7F1F2;
```

Anything with a ```$``` in front of it is a variable in Sass. A variable is a reusable bit of CSS. So in the future, instead of having to remember the actual hexcode for our red brand colour we can just write ```$brand-color```.

> Variables are one of the key strengths of Sass over plain old CSS. For a quick run down of the great things Sass introduces see [the Sass website for more info](http://sass-lang.com/guide).

In our ```application.css.scss``` file delete the contents and write the following:

```sass
@import "variables";
/*
 *
 *= require_self
 */

body {
  background-color: $brand-grey;
  margin: 0;
  font-family: $brand-font;
  
  #main {
    padding: 70px;
  }
}

nav {
  background-color: #fff;
  padding: 30px;
  
  .nav-container{
    padding-left: 20px;
  }
  
  li {
    display: inline;
    padding: 10px;
  }
  
  a {
    color: $brand-color;
    text-decoration: none;
    font-size: 20px;
  }
}
```
Here on the first line we are importing the ```_variables.css.scss``` file. We don't need to include the underscore or the file extension. Sass is smart enough to know you're importing a Sass file. Just make sure you have the semi-colon after each import statement. If you don't your app will blow up with Sass errors.

> You might ask what is the point of an underscore? Well, it tells Sass that you don't want it to be converted to CSS. That is, you are using it to be imported somewhere so you can control the order of your Sass rather than be turned into an individual file called variables.css. If you don't include the underscore Sass may try to convert it to CSS which is not what we want.
> The underscore also helps other developers know it is included, or rather **imported**, elsewhere

The comments that come after the import statement are the "sprocket" asset pipeline syntax. Essentially this is where we tell Rails what to require and how to order things. I like to keep this simple so all i am doing is telling Rails to compile everything in that file (including what is in that file) into ```application.css```.

> ## Super Sprockets
> Sprockets are a key part of the "Rails asset pipeline". 
> Essentially the tooling

Inside this file you should also see where we have used the Sass variables. We imported our variables and put them to use to define our ```background-color```, ```font-family``` and link ```color```.

Another thing you may notice about our file is that be can embed elements inside other elements like so:

```sass
.mother {
  .daughter {
  
  }
  .son {
  
  }
}
```

This allows you to nest elements and classes with ease but also create powerful namespaces for your CSS without the overhead of manually writing lots of CSS.

That wasn't a ton of extra styling but we've added a touch of class to our app. And really, we got a good look at scss.

We'll return to that later as our app gets fleshed out futher.

## Create your User model

In order to kickstart out app we need to create our database model of our users.

Any quality app reflects serious thinking about what makes a good model or representation of the thing we want to build.

When it comes to a user, we need to think about what we need to use within the app, but also what our users will expect to reflect. That is, they may want the ability to indicate individual authorship or specialisms.

Luckily we don't have to be perfect with Rails. There is always the ability to add and improve on our models later.

For now, let's represent our users with the following database information:

* First name
* Last name
* organization
* biography
* Job title
* email
* password

To do this, we'll set up a basic version of this as a generic Rails model, afterwards adding the powerful authentication gem Devise to provide the management of passwords, signing in and emails.

Get back into the command line and run the following command:

```bash
rails g model User first_name:string last_name:string organization:string biography:text job_title:string email:string
```

This will invoke activerecord to create a "migration", a file that represents our user model called ```app/models/user.rb``` as well as well an Rspec test for that model

> A database migration is essentially a map of your database. The migration name  refers to the fact that in Rails it represents an image of your database's scheme or structure at a particular moment in time. You can therefore move forward or baskwards through your migrations. To learn more about Rails and database migrations, see the [Rails ActiveRecord Migrations documentation](http://edgeguides.rubyonrails.org/active_record_migrations.html).

Let's look at our user model:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
end
```

Hmmm, not a lot happening there!

Most of our changes are found in our unique migration file. My filename will be named differently than yours but it will be located in the same directory, namely ```/db/migrate/{numbers}_create_users.rb``` 

Inside this file is a simple ruby class and method that creates the user table in our MySQL database.

In the method called change it creates a table with the name users and creates all of the columns after ```do``` using the placeholder ```|t|```.

All of the things we asked Rails to create are there however, there is an extra one at the moment called ```t.timestamps```.

This just creates a created_at and updated_at set of columns which are extremely helpful in versioning and tracking things in your database.

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :organization
      t.text :biography
      t.string :job_title
      t.string :email

      t.timestamps
    end
  end
end
```
To make sure that our database is up to date we need to run ```rake db:migrate``` which tells rake to action the database actions in our migration file. So, do that now, run:

```bash
# incorporate our user model into the database
rake db:migrate
```

This will output something like the below:

```bash
== 20150107214248 CreateUsers: migrating ============================
==========                                                           
-- create_table(:users)                                              
   -> 0.0149s                                                        
== 20150107214248 CreateUsers: migrated (0.0151s) ===================
==========   
```

We are pretty much ready to use the powerful Gem Devise but first let's update our user.rb model file to include what fields in the database are included.

This is a personal thing but to me it seems vital for clarity to highlight what each model has in its database. To that end, add the following to our ```app/models/user.rb``` file:

```ruby
# update app/models/user.rb
class User < ActiveRecord::Base
  #   string :first_name
  #   string :last_name
  #   string :organization
  #   text :biography
  #   string :job_title
  #   string :email
end
```

Awesome. let's set up Devise.

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

That is a whole ton of files. Essentially they provide the forms for users to sign up, in and out of your app. We'll cover styling Devise later, for now let's move onto creating a blog-like article model.

## Seeding your db and validation

Whenever you set up something that can create, update, or delete things from your database you need to set up validations.

That is, set up systems to make sure the data you want to be saved is saved.

In Rails you can set up all manner of points to do this. That is, you can validate data on the "front-end" with the new HTML5 input attributes or JavaScript, with your controllers which can take and sanitize and check information before saving. You can also check or validate your data in your model. The reflection of your database and application's structure in code.

In this section we will set this up for our user model before creating a few users to sign in with.

#### add data validation

Time to crack open our ```user.rb``` model.

At the moment our User class inherits from ActiveRecord::Base all of Rails' default functionality. Let's pull in some of that to act on our user model.

```ruby
class User < ActiveRecord::Base
  #   string :first_name
  #   string :last_name
  #   string :organization
  #   text :biography
  #   string :job_title
  #   email :string
end
```

Luckily we placed comments for each column in our database's user table so we can knock down each task without struggling to remember what we need to validate before saving to our database.

The most basic validation we want to enact here is that each database column is filled in.

However, with our biography record we'll also want it to be longer than a couple of words, so we'll have to ask for a minimum length. 

On the flipside though, we don't want John from Accounting to ramble on and on about his Hobbies so we'll need some kind of length limit.

In regard to our email, we'll want to be sure that what people have provided is an email that doesn't already belong to an account.

If we hadn't chosen a mature framework like Rails, we would have to build a lot of this functionality ourselves.

Luckily for us, Rails brings a lot of "magic".

> The reality is NONE of this is magic. What has happened is a lot of developers have suffered building these things before and so often that they created all of the most common validations they could think of and gave Rails the ability to call these things. In your career as a developer you'll soon be extending, changing or building alternatives depending on special cases but Rails provides the basics you need.

A great way to get to know what Rails provides is the Rails Guides. And thankfully Rails provides [an extensive summary of the validations on offer here](http://guides.rubyonrails.org/active_record_validations.html).

I strongly recommend reading through that guide and every guide in the series several times. Don't ever be put off doing so. They are written by Rails experts.

Looking at the examples we can see that adding a validation consists of:

1. write the word validates
2. refer to the database column in question,  like ```:email```
3. select the validation method you prefer with any specific

> insert picture backing this process up

Right, enough of that, let's write some.

Let's make sure our names are present. Add the following:

```ruby
  validates :first_name, presence: true
  validates :last_name, presence: true
```

If we were to do this for each that would be six lines. Not terrrible, but is there an easier way? yes.

Let's refactor that code so that we validate the presence of all of our database columns at once. We can do it easily by just adding commas and our database columns like so:

```ruby
  validates :first_name, :last_name, :organization, :biography, :job_title, :email, presence: true
```

Awesome, now no one will be able to save anything to our database without an entry.

Next let's ensure our biography is at least 120 characters long. Write the following:

```ruby
  validates :biography, length: { minimum: 120, too_short: "%{count} characters is too short, you need at least 120 characters" }
```

Here we have done something a little different! We have repeated the first two steps as before, offered the keyword validates and then the column we want to validate. But this time, we added a hash which is attached to ```length:``` to provide some further configuration than just a minimum length.

> ### Ruby Hashes
> You'll notice hashes quite a lot in terms of configuration in Rails. In Ruby a hash is created by using curly braces ```{}``` and including a **key** and a **value** within quotes. Here is an example of a hash:
> ```
> {"key" => "value", "name" => "Andrew"}
> ``` 
> As you can see you link a key with the value using ```=>```. You also seperate the key/value pair with a comma to add another one.

Although it is smashing we have a minimum, someone could still copy-paste their novel into ```:biography``` and save it to our database. We'd rather they didn't do that. Just for performance sake or something something.

> INSERT JOKE CARTOON HERE

Let's add a maximum to our length. Looking through the Rails documentation they have an example very similar to what we want. Let's just add in the maximum after a comma. Our code should look something like this:

```ruby
validates :biography, length: { minimum: 120, maximum: 400, too_short: "%{count} characters is too short, you need at least 120 characters", too_long: "%{count} characters is too long, you need to keep it under 400 characters" }
```
So, we added:

**+**  ```maximum: 400```

**+** ```too_long: "%{count} characters is too long, you need to keep it under 400 characters"```

inside our hash.

> add explanation for %{} in ruby

Let's also validate that the email provided is unique. This follows pretty much the first example but this tome focusing on uniqueness rather than presence like so:

```ruby
validates :email, uniqueness: true
```

> There are other validations we could add like checking for an email conforming to a certain case. I'm not going to do that here but have a go, see if you can google up yourself a storm and add that in!

Right, we've pulled in a lot of Rails there. We added validations to our user model. We've checked that things exist and aren't left empty.

We then set the required minimum and maxiumum length for our biography as well as some custom error messages.

We finished off making sure that no one could make several accounts with the same email account.

We've now got a solid database model of our users set up, we have also used Devise to do some work for us setting up those users as well as all of the frontend.

But we are missing something, the C in MVC, our user controller!

Let's do that in our next section.

#### create a user controller

Back in your command line run the following line:

```bash
rails g controller Users index show
```

Here we have run another Rails generate command. This time we have told it to create a controller and the related views for our User pages and model. It creates another whole load of files.

The tendency of Rails to splurt out a lot of files can be very intimidating to a newcomer. Don't worry about it. You'll soon get it. And soon know what files to ignore, what files to delete and what files to focus on.

Talking about focus, open up your user_controller.rb file.

Inside it you should see:

```ruby
class UsersController < ApplicationController
  def index
  end

  def show
  end
end
```

Those two Ruby methods don't do much this second. Due to Rails conventions they automatically connect to the users/index page and users/show pages but not much else.

> This is to say, Rails takes the method name within a class like UserController inheriting from the ApplicationController to mean look for a ```.html.erb``` page called the same thing. So, within our ```~/app/views/``` folder, Rails will look for a directory called ```/users/``` and expect to see a ```.html.erb``` file called ```index.html.erb``` and it will render that when people hit the corresponding route.

Let's add some real code and offer two traditional "RESTful" routes. An index route that displays every user in the database, and a show route that gives us an individual user's page.

So, we have two tasks:

1. Create a controller method that lists all of our user
2. Create a controller method that lists a specfic user when that specific user is asked for

As Ruby is an object-oriented programming language, and Rails a reflection of that, what we want to do is create, within our controller class, a blueprint of methods to take in those situations. 

Because we want to use our methods in our views, we need to define things as **instance variables**. That is, things like ```@user``` rather than just ```user```. This is because in Rails, anything that gets exposed in a view should use an instance variable over a local one - it results in less code.

> ### Instance Variables
> I'm kinda presuming you've seen and written an instance variable before. However, if you haven't or you feel a little shaky on them, let's quickly cover the idea behind them.
> 
> An instance variable is a variable defined in a class, like our UserController. Further to this though, the instance variable creates a new instance specific to every new object created by the class.
>
> So, an instance variable tells Ruby to create a variable specific to every object we create.
>
> This means, if we create three users with the names Bill, Bob and Berlinda that each user (and their individual object that they are defined in) has a variable called ```name``` which is specific to them. So, when we ask Ruby or Rails for our users in the view, we could get back something like this:
> 1. ```id: 1 name: Bill```
> 2. ```id: 2 name: Bob```
> 3. ```id: 3 name: Berlinda```
>
> This is because each instance of an object, when it gets created defines its own user variable.
> 
> Another way of thinking about this is a company that asks new employees what computer they want when they join. Bill asks for a Linux laptop, Bob a Windows desktop and Berlinda a Mac. Every instance of a new employee ensures that @computer is filled in, and every request is specific to each employee.
> 
> In Ruby we define an instance variable with an @ symbol at the front. So, user is a local variable, while @user is an instance variable.

In our first method called ```index``` we want to call all of our users. We start by defining an instance variable. We are using an instance variable because we want each object to have an instance of this variable and also because we are going to use this instance in our views.

Write the following inside our ```user_controller.rb``` file:

```ruby
def index
  @users
end
```
Next thing we want to do is get all those users out of our database model and into your controller. We do this quite simply by calling the User model we defined with the ```.all``` method.

As you could probably guess, the ```.all``` method gets ***all*** of our users.

Update the  ```user_controller.rb``` file:

```ruby
def index
  @users = User.all
end
```

The .all method comes from using ActiveRecord the default Rails ORM or object-relational mapper.

> To find out more about ActiveRecord see [The corresponding Rails ActiveRecord querying guide](http://guides.rubyonrails.org/active_record_querying.html)

An ORM basically creates a version of common SQL (or NoSQL) commands but lets you action those in the programming language of your choice.

An ORM is basically an API for your data. A programmable interface.

If you are wondering why we put User instead of something else... that is just the name of the model you want to call. If we had called our User model, Cat instead, we would call:

```ruby
# Code for a cat management system
def index
  @cats = Cat.all
end
```

> INSERT IMAGE/DRAWING

So with ActiveRecord you place the model name, the method you want to call/use and then any additional parameters you want to use after that. So, here's an example:

```ruby
def cats_i_found
  @cats = Cat.last(5)
end
```

This bit of code inside my controller calls my Cat model and asks for the last 5 cats I put into the database. So, my ActiveRecord query is constructed like so:

```{name of model}.{name of method}(additional parameters)```

The best way to find out the methods available for your Rails app using ActiveRecord is the [querying documentation](http://guides.rubyonrails.org/active_record_querying.html).

Let's leave the cats for now and get back to our CMS.

Our index controller method will now get back all of our users, which we can place into our user ```index.html.erb file```.

Let's do that. Write the following erb into the file:

```erb
<!-- ~/app/views/users/index.html.erb -->
<h1>Muskox CMS</h1>

<p>Well, hello <%= @users.first_name %>!</p>
```

Before firing up that server however, we need to create an actual user! If we don't have a user Rails will splurt out errors.

#### seed the db and sign in

Let's create that user. We will do this by using the ```rake seed:db``` task. 

first things first we need to create a user in that file.

you locate it in /db/seeds.rb

Add the following:


```ruby
User.create(first_name: 'Andrew', last_name: 'Duckworth', organization: 'Allyooop!', biography: 'Once upon a time, a long time ago someone had to come up with some filler bio information and what he did was ramble on a bit', job_title: 'developer', email: 'grillopress@gmail.com')
```

Hit the view

Add additional resources

change route to resources


#### create a view that reflects the user's name


## Scaffold your Article model

## Scaffold your service model

## Scaffold your directory model
