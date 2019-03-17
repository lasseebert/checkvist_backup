checkvist_backup
================

**NOTE**: This repo is no longer maintained

A simple ruby-script to create backup from checkvist

Requirements: `ruby 1.9.2` `tar`

How to use
----------

    Usage: checkvist_backup.rb [options]
      -v, --verbose                    Output information
      -l, --login <email>              Your login (email)
      -k, --api_key <key>              Your API key
      -d, --output_dir <dir>           Where to place the output file (defaults to current directory)
      -f, --output_filename <file>     Name of the output file (defaults to "checkvist.tar.gz")
      -a, --include_archived           Set to include archived checklists
      -h, --help                       Display this screen

Example
-------

    ./checkvist_backup.rb -avl yourname@domain.com -k yoursupersecretkey

This will produce the file `checkvist.tar.gz` in the current directory containing all lists including the archived lists.

Cron
----
Cron is a great way of scheduling a backup.

If you're using RVM, you need to load that from Cron before it can execute the script.

This will produce a daily backup that will override the previous each day:

    0 0 * * * bash -c 'source /home/<username>/.rvm/scripts/rvm && /usr/bin/env ruby /path/to/checkvist_backup/checkvist_backup.rb -al <checkvist login> -k <checkvist api key> -d /path/to/backup/output/file/'
