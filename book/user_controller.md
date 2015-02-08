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

An ORM is basically an API for your data. A programmable interface. ActiveRecord basically creates Ruby versions of SQL, the structured query language that powers our database-driven app

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

Our index controller method will now get back all of our users, which we can place into our user ```index.html.erb``` file.

Let's do that. Write the following erb into the file:

```erb
<!-- ~/app/views/users/index.html.erb -->
<h1>Muskox CMS</h1>

<p>Well, hello <%= @users.first_name %>!</p>
```

Before firing up that server however, we need to create an actual user! If we don't have a user Rails will splurt out errors.

#### seed the db and sign in

Let's create that user. We will do this by using the ```rake seed:db``` task. 

first things first we need to create a user in our ```seeds.rb``` file.

you locate it in ```/db/``` directory.

Add the following to ~/db/seeds.rb:


```ruby
User.create(first_name: 'Andrew', last_name: 'Duckworth', organization: 'Allyooop!', biography: 'Once upon a time, a long time ago someone had to come up with some filler bio information and what he did was ramble on a bit', job_title: 'developer', email: 'grillopress@gmail.com')
```

Naturally, feel free to User.create() as many users as you want with the details you want to include.

That is just me.

> Feel free to drop me an email any time to chat about Rails.

After you have filled up that file, fired up your terminal and run the following command:

```bash
rake seed:db
```

This will load into your database your seed file.

After you have run the file delete the contents of your ```seed.rb``` file. If you don't you may accidentally re-create everything you have just put in.

Right, you should now have at least one user in your database!

Let's see our user view in action.

Start the Rails server as before:

```bash
rails s
```

After doing so visit your provided URL and port number with the relevant user route of: ```/users/index```

If you are developing locally this should be:  ```http://localhost:3000/users/index```

You should see a rather exciting view which says hello to your user and their first name! Hurrah. Fame and fortune awaits.

As well as listing "all" of our users, we want the ability to list individual users.

This is a common pattern in websites. You have a main page where everything is summarized. A list of blog posts say, and individual pages per each blog.

If you have used any sizable app or site that holds many users you may have visited a URL that features a route with the following pattern: ```/users/21398/```

Taking another example, think of the popular Internet Movie Database site. Each film title is logged and the URL features the number assigned to it. 

When we visit a page of a film we are interested in you see an URL like [http://www.imdb.com/title/tt0109382/](http://www.imdb.com/title/tt0109382/)

This is what we want to replicate, but with our user controller.

To do that we need to create a **"show"** method in our users_controller. Write the following in ```~/app/controllers/users_controller.rb```:

```ruby
def show
  @user
end
```

Here we have created a method for our show action. The choice of show is not an accident. It is a Rails, and RESTful, convention. Where possible we'll stick with that when we can.

> explanation of REST again

Inside the show method we have created an instance variable. Unlike our ```index``` method we have used the singular of @user instead of @users.

This is because we are getting one user, rather than a whole gang of them.

When someone hits our ```/users/show``` route by giving us a specific user ID, we want to give them a page reflecting that user.

> explain how the route is show, but actually it is a number

To achieve this we need to grab the route that our visitor has typed in (something like ```/users/1```) and take that number and use it to find a user with a corresponding ID.

In terms of finding a user this is pretty easy in Rails. Using ActiveRecord we have a method available well named called .find which coupled with a bracket we can use to select a specific user.

That is, we could call User.find(1) to get the user with the ID of 1.

The structure here is:

```
{model we want to call}.{find, our ActiveRecord method of choice}{ our number inside brackets like so (1)} 
```

Naturally we don't want to always reply with our first user because, however smashing my bio is, that isn't a custom app by any stretch of the imagination.

Our code looks like this currently:

```ruby
def show
  @user = User.find(1)
end
```

To get any particular user we need to access the visitor's URL or route. To do this we can use the Ruby method of params.

Params, short for parameters, is a Ruby method that lets us grab certain URL attributes to manipulate or call other bits of code or data.

> Sinatra book explantation here of Params

Params lets us access the URL, but as with all code we need to drop it into a placeholder. To do that, we create a symbol called :id inside some squarebrackets.

Our code then, should look like this:

```
def show
  @user = User.find(params[:id])
end
```

Let's add some code to our users view so that we can reflect our code and check it does what we expect.

In the ```~/app/views/users/show.html.erb``` file delete the contents and write the following in:

```erb
<h1><%= @user.first_name %>'s page</h1>
```
Run ```rails s``` and type in ```http://localhost:3000/users/1```

Did it work? No. The issue here is that our route is not set up to access to :id params, our controller is, but our route just expects to render a static resource called ```show.html.erb```.

Open your routes file, located here: ```~/config/routes.rb``` , and update the show route to the following:

```ruby
get '/users/:id', to: 'users#show'
```

What this does is take the input after ```/users/``` and assigns that to the :id params symbol we called in our controller code.

The to: bit just tells Rails that we want it to write up the /users/:id route and connect it to the users_controller.rb file and the show method. So essentially, that last bit, ```users#show``` says:

```
'{name of controller}#{method inside the controller file}'
```

Run ```rails s``` in the console again, unless your Rails server is still running, and visit your local website [```http://localhost:3000/users/1```](```http://localhost:3000/users/1```).

You should now see a lovely greeting for our first user

