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