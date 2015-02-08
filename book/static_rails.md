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
