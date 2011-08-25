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

Sphinx
------
    su - postgres
    createlang plpgsql [database]

PayPal: test account
--------------------

> Business Account

> > login: visent_1314080137_biz@gmail.com

> > password: 314082241

> Personal Account

> > login: visent_1314081983_per@gmail.com

> > password: 314110980

Payment Method
--------------

> Credit card must be named "Credit Card"

> PayPal must be named "PayPay"

> PayPal for virtual must be named "vPayPal" and "no shipping"