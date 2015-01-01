# Building a CMS with Rails

In this book we will build a modern CMS with Rails. 

We will create a dashboard that our users can use to create articles and update other important information.

This CMS will not be a traditional CMS where they can directly edit and update the fontend of their site. The idea is that you let the content creators create the content and leave the design and frontend alone.

We will let the users set certain features, like the featured service or article, but the design, the "look and feel" will be not be something we will let them edit.

## Install & Configure MySQL

## Create your Rails Project

run in your console the following command:

```bash
$ rails new muskox -d mysql -T
```

The `rails new` command tells the rails gem to scaffold out the initial Rails template and the word after new is what it will call the project. In our case, we have called is muskox.

> We are calling our CMS muskox. A [muskox](Codio.com) is a buffalo/sheep thing that has survived since the last Ice Age, a bit like the need for CMSes

The "flags" we raised are `-d mysql` and `-T` which stand for:

* `-d` = change database
* `-T` = remove default test framework

We designated mysql as the database we wanted to use with the `-d` flag and we did that by writing it after.

## Create your User model and set up Devise

## Scaffold your Article model

## Scaffold your service model

## Scaffold your directory model
