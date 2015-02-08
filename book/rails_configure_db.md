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
* Did you run Rails S, what is that saying?
* Are you in the Rails directory when you ran that command?
* If it mentions that no DB exists, run ```rake db:create db:migrate``` and ignoring the messages run Rails S again, does that work?

Hopefully everything is working smoothly. Right, time to do some building. In the next chapter we'll create our homepage