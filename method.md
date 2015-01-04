# Building a CMS with Rails

In this book we will build a modern CMS with Rails. 

We will create a dashboard that our users can use to create articles and update other important information.

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

```GRANT ALL PRIVILEGES ON``` = give the ability edit the following db

 ```muskox_db.*``` [or whatever db you called it!] = the database and tables the command to allow a user to edit relates to

```TO 'rails'@'localhost'``` = user the command relates to

```IDENTIFIED BY 'secure-password'``` = as long as they have the password of secure-password

So altogether, give the ability to edit the database muskox_db and all the data and tables within it to the user called rails as long as it is using secure-password as the password.

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
Fantastic. We have a lovely new user and database set up for our rails project. Time to create that and put that database to use.

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

make sure you `cd muskox` afterwards to move into the directory. If you don't the following commands won't work.

## Setting up your Rails DB

Our next step is to ensure our database is configured correctly with Rails. Rails is pretty awesome but it is not a mind-reader. We'll have to make sure we get our MySQL database connected and talking to each other.

Inside your rails project, find open up the **database.yml** file located in the **/config** folder.

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

Like you have likely seen before, that chart is made up of a key, our revenue in a particular year, and a value, the amount we made.

Hopefully that has helped a little bit.

> Another way of thinking about keys and values is like a spreadsheet with lots of cells. In one row you have things like: name, job, city. These are the keys. In a row below you have things like: Andrew, Developer, Sheffield. So, in one row you have a key and the other a value with each value belonging to a key.

#### Back to our database.yml file

So, in terms of our database.yml file we need to update the key value pairs with information that relates to our database we created.

The default keys are inhereted by the "development", "test" and "production" sections. That is, you define general keys and values at the top and the rest of the sections use this syntax ```<<: *default``` to use all those keys and values without having to repeat them.

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

This should boot up your WEBrick server with the second line indicating which URL the rails app is working on:

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

Hopefully everything is working smoothly. Right, time to do some building. In the next chapter we'll create our homepage

## Create your homepage

In this chapter we are going to create our basic homepage. We are going to use the default rails generators to do use. We will then add our first "views" so that we can see this site.

We will also touch on Rails routing to make sure that when someone goes to the route "/" they see the homepage we have designed rather than the basic rails app homepage.

Throughout this chapter we will also add some styles to our app so it doesn't look terrible. We will use SASS which is a developer friendly CSS preprocessor (essentially CSS with developer focused shortcuts ) 

#### Update gemfile

remove coffeescript, add puma

#### generate our first controller

rails generate controller pages index

gem gem-command resource-to-generate name-of-resource sub-resource

#### update our root routes

#### update corresponding view file

#### add some further styling

## Create your User model

## Set up Devise

## Scaffold your Article model

## Scaffold your service model

## Scaffold your directory model
