gitreceive
==========

Tool that sets up a git server for running scripts or hitting HTTP
endpoints when you push code to it.

## Requirements

You need a Linux server with git and sshd installed.

## Installing

On your server, run:

    $ curl https://raw.github.com/progrium/gitreceive/master/installer | bash

This will install `gitreceive` into /usr/local/bin

## Using gitreceive

#### Set up a git user on the server

    $ gitreceive init
    Created receiver script in /home/git for user 'git'.

#### Modify the receiver script

By default it will POST all the data to a RequestBin:

    $ cat /home/git/receiver
    #!/bin/bash
    URL=http://requestb.in/rlh4znrl
    echo "----> Posting to $URL ..."
    curl \
      -X 'POST' \
      -F "repository=$1" \
      -F "revision=$2" \
      -F "username=$3" \
      -F "fingerprint=$4" \
      -F contents=@- \
      --silent $URL
    

#### Create a user by uploading a public key from your laptop

    $ cat ~/.ssh/id_rsa.pub | ssh you@yourserver.com "gitreceive upload-key progrium"

#### Add a remote to a local repository

    $ git remote add demo git@yourserver.com:example.git

The repository `example.git` will be created on the fly when you push.

#### Push!!

    $ git push demo master
    Counting objects: 5, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (3/3), 332 bytes, done.
    Total 3 (delta 1), reused 0 (delta 0)
    remote: ----> Receiving progrium/gitreceive.git ... 
    remote: ----> Posting to http://requestb.in/rlh4znrl ...
    remote: ok
    To git@gittest:progrium/gitreceive.git
       59aa541..6eafb55  master -> master

## So what?

You can use `gitreceive` not only to trigger code, but to provide
feedback to the user and affect workflow. Use `gitreceive` to:

* Deploy on any arbitrary platform
* Run your build/test system as a separate remote
* Integrate custom systems into your workflow
* Push code anywhere

## License

MIT
