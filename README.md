# Adaptive Labs Technical Test

A simple web application to consume a Twtter-like RESTful API and display messages that are all about Coke!

## Configuration

```
bundle install
rake db:create db:migrate
```

## Starting the application

Nothing special here, just start the app as you would with anything Rails!

```
rails s
```

## Using the application

To view messages all about Coke, visit the messages page at `/messages/index`.

## Application testing

This application is covered by automated tests written using Cucumber, Capybara, and RSpec. The suite is initiated using Rake.

### Running feature tests with Cucumber

```
rake cucumber
```

### Running unit tests with RSpec
```
rspec
```
