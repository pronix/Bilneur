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


Xapian:
-------
    uuid-dev-2.17.2
    wget http://oligarchy.co.uk/xapian/1.2.0/xapian-core-1.2.0.tar.gz && tar
    ./configure --prefix=/usr/local && make && sudo make install
    wget http://oligarchy.co.uk/xapian/1.2.0/xapian-bindings-1.2.0.tar.gz && tar
    ./configure --prefix=/usr/local XAPIAN_CONFIG=/usr/local/bin/xapian-config
    make && sudo make install
    sudo ldconfig
