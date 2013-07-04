gitreceive
==========

Creates an ssh+git user that creates repositories on the fly and lets you run scripts or hit HTTP endpoints when you push code. 

Build your own Heroku. Push code anywhere. 

It's just not a `post-receive` hook. It's a powerful wrapper around `pre-receive` giving you easy access to the code that was pushed while still being able to send output back to the git user.

## Requirements

You need a Linux server with `git` and `sshd` installed.

## Installing

On your server, download https://raw.github.com/progrium/gitreceive/master/gitreceive to a location on your $PATH and make it executable.

## Using gitreceive

#### Set up a git user on the server

This automatically makes a user and home directory if it doesn't exist. 

    $ sudo gitreceive init
    Created receiver script in /home/git for user 'git'.

You use a different user by setting `GITUSER=somethingelse` in the
environment before using `gitreceive`.

#### Modify the receiver script

As an example receiver script, it will POST all the data to a RequestBin:

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
    
The username is just a name associated with a public key. The
fingerprint of the key is sent so you can authenticate against the
public key that you may have for that user. 

The repo contents are streamed into `STDIN` as an uncompressed archive (tar file). You can extract them into a directory on the server with a line like this in your receiver script:

    mkdir -p /some/path && cat | tar -x -C /some/path


#### Create a user by uploading a public key from your laptop

We just pipe it into the `gitreceive upload-key` command via SSH:

    $ cat ~/.ssh/id_rsa.pub | ssh you@yourserver.com "gitreceive upload-key progrium"

The username argument is just an arbitrary name associated with the key, mostly
for use in your system for auth, etc.

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

The receiver script did not attempt to silence the output of curl, so
the respones of "ok" from RequestBin is shown. Use this to your
advantage! You can even use chunked-transfer encoding to stream back
progress in realtime if you wanted to keep using HTTP. Alternatively, you can have the
receiver script run any other script on the server.

## So what?

You can use `gitreceive` not only to trigger code on `git push`, but to provide
feedback to the user and affect workflow. Use `gitreceive` to:

* Put a `git push` deploy interface in front of App Engine
* Run your company build/test system as a separate remote
* Integrate custom systems into your workflow
* Build your own Heroku
* Push code anywhere

I used to work at Twilio. Imagine pushing a repo with a TwiML file to a
gitreceive repo with a phone number for a name. And then it runs that
TwiML on Twilio and shows you the result, all from the `git push`. 

Another idea: When it's so easy to handle pushed code, how about
creating a screen in the office that will display whatever code is
pushed to it.

## Contribute

This whole system is contained in a single bash script less than 100
lines long. Let's keep it simple, but I'm definitely open to contribution!

## Big Thanks

DotCloud

## License

MIT
