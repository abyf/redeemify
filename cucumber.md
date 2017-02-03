Contribution
You can start work on any aspect of the app you want to improve
It may be refactoring
    * particular controller
    * tests
    * views
Fixing bug
    * If you find a bug, you have to be confident that it is reproducible
        It requires test (RSpec or Cucumber)
Implementing new feature
    * You can suggest new feature and start work on it

You can also choose something from the existing issues on
* GitHub
    https://github.com/strawberrycanyon/redeemify/issues
* Pivotal Tracker
    https://www.pivotaltracker.com/n/projects/1923595

Homework

Features
    all features/.*feature files to better understand how the app works
    from different perspectives

Read
    doc/cucumber_best_practices.md
    doc/notes_and_tasks.md
    
    Articles:
        Write Great Cucumber Tests
            https://saucelabs.com/blog/write-great-cucumber-tests
        Cucumber Best Practices
            https://github.com/strongqa/howitzer/wiki/Cucumber-Best-Practices

How to log in

As a User
    In seeds.rb both lines should be commented out (32 and 40)

As a Provider
    Comment out line 40

As a Vendor
    Comment out line 32

Pitfalls

    in config/environments/development.rb:
    line 4 should be commented out
    # OmniAuth.config.test_mode = true

    You have to update database and clean cookies
    rake db:reset

To start PostgreSQL serve
