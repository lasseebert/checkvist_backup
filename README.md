checkvist_backup
================

A simple ruby-script to create backup from checkvist

Requirements: `tar`

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

