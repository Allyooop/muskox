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
rails g model User first_name:string last_name:string organization:string biography:text job_title:string
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
end
```

> If you noticed we haven't added an email field yet, don't worry. Devise will add that for us when we install it

Awesome. let's set up Devise.