Install
-------

    bundle install --path vendor/bundler
    copy config/database.yml.example to config/database.yml
    rake db:create
    rake db:migrate
    rake db:seed

Load sample data
----------------

    rake db:sample

Social Connect
--------------

> Setting social account: /admin/authentication_methods

Testing
-------

> Cucumber
> -------
> > rake cucumber

> Rspec
> -----
> > rspec spec