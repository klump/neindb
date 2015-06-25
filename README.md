NeinDB
======

Installation
------------

Requires at least Ruby on Rails 4.2, Ruby 2.2.0 (via rbenv) and Postgresql 9.4 and sidekiq.

Start out by settings up rbenv and installing Ruby 2.2.0.
Install Postgresql and setup a user and give him accecss to a database.
NeinDB requires superuser access to this database.

To install the actual app:
```
git clone GIT_URI
cd nein_db
bundle install
```

To manage sidekiq, you can use the following init script.
The script is based on the one in the sidekiq documentation.
You might have to adopt the user (neindb) and the paths to your environment.
Place it in the `/etc/init` directory and start it with `service NAME restart`.

```
description "NeinDB Sidekiq worker"
author "Alexander Kratzsch <alex@devrandom.se>"

start on runlevel [2345]
stop on runlevel [06]

# restart the process if it crashes
respawn
# respawn a max of 3 times within 30 seconds
respawn limit 3 30

script
# this script runs in /bin/sh by default
# respawn as bash so we can source in rbenv
#exec /bin/bash <<'EOT'
exec su - neindb -c /bin/bash <<EOT
  # rbenv
    source /home/neindb/.bashrc

    cd /home/neindb/nein_db/
    exec /home/neindb/.rbenv/shims/bundle exec sidekiq -c2 -g neindb -e production 2>&1 -L /home/neindb/nein_db/log/sidekiq.log
EOT
end script
```
