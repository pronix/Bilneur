Install
-------

    bundle install --path vendor/bundler
    copy config/database.yml.example to config/database.yml
    rake db:migrate
    rake db:seed

Load sample data
----------------

    rake db:sample

Testing
-------

> Cucumber
> -------
> > rake cucumber

> Rspec
> -----
> > rspec spec
