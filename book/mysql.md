# setting up MySQL for our Rails app

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
