# pluginhook

A simple plugin system for Bash programs that's better than regular hook scripts.

## Hook Scripts

Lots of shell-based systems use hook scripts as a means to allow users to extend or customize behavior. Popular examples
are [Git](https://www.kernel.org/pub/software/scm/git/docs/githooks.html) and [SVN](http://svnbook.red-bean.com/nightly/en/svn.ref.reposhooks.html), but many systems from [libvirt](http://www.libvirt.org/hooks.html) to [NPM](https://npmjs.org/doc/scripts.html) to [OS X](http://superuser.com/questions/295924/how-to-run-a-script-at-login-logout-in-os-x) use this pattern. Shell scripts make 
for a great way to expose hooks because the shell environment is ubiquitous and lets you easily call into
scripts or programs written in your language of choice. 

## What's wrong with hook scripts?

The standard implementation of hook scripts is to have a shell script with an execute bit in a particular location
that's named after the hook. The most famous example is the "post-commit" hook of SVN, which if `hooks/post-commit`
exists in your repository directory with an execute bit, it will trigger this script after each commit. Some systems
let you register hooks by providing a location instead of using convention. 

However, in either case, each hook points to **one** script. The only way for a third-party piece of software to 
"hook in" is to install itself as the one hook script, or have you manually install it by calling it from your 
existing hook script. What's more, if a third-party piece of software wants to use multiple hooks, you have to
deal with this several times over. Not only is this a hassle, but leads to complex and un-obvious configurations.

## pluginhook: Plugins as a better way

Let's take the core benefits of hooks and re-structure it slightly:

 1. Instead of focusing on hook scripts, we focus on plugins -- groups of hook implementations
 1. Like hook scripts, plugins are active by being in a certain place. But they can be named anything
 1. Multiple plugins can handle a hook. Either for fanout event triggering, or for pipeline filtering
 
And plugins are still just shell scripts. They just implement a simple protocol:

    #!/bin/bash
    case "$1" in
      post-commit)
        # do something after a commit
        ;;
        
      *)
        exit 1
        ;;
    esac
    
A switch on the first argument is used to determine the hook. The rest of the arguments are whatever
arguments are passed for that hook. It also receives STDIN if the trigger passes it. For any hook you
don't care about in this plugin, you exit non-zero. 

## Triggering plugin hooks

You use the `pluginhook` command to trigger hooks as if you might call a traditional hook script directly.
Where before you might have triggered by calling something like:

    hooks/post-commit $REV $USER

You'd instead trigger like this:

    pluginhook post-commit $REV $USER

The `pluginhook` command simply loops through all plugin scripts found in the path defined by the environment
variable `PLUGIN_PATH` and passes the same arguments. This means installing a plugin is as simple as putting
it in your `PLUGIN_PATH`. The result is that any plugin that implements the `post-commit` hook will have its 
implementation run, and any plugin that doesn't will just exit and be ignored.

## Pipeline filtering with plugins

You don't just get a "broadcast" mechanism for arguments. You also get stream pipelining. If you pipe a stream
into pluginhook, it will be passed *through* each plugin, letting each plugin act as a filtering process. By clearly
defining how a hook should be used and how it can play well with others, this becomes very powerful infrastructure.

Here is a plugin we'll call `upper` that implements a `text` hook:

    #!/bin/bash
    case "$1" in
      text)
        cat | python -c "import sys;sys.stdout.write(sys.stdin.read().upper())"
        ;;

      *)
        exit 1
        ;;
    esac
  
Here is a plugin we'll call `reverse` that also implements a `text` hook:

    #!/bin/bash
    case "$1" in
      text)
        cat | ruby -e "puts STDIN.read.strip.reverse"
        ;;

      *)
        exit 1
        ;;
    esac
    
One plugin uses Python, the other uses Ruby, but they're both used when you run with pluginhook:

    $ echo "hello world" | pluginhook text
    DLROW OLLEH

Only plugins that implement a hook are used as filters for that hook, so there's no need to implement pass-through hooks if a
plugin doesn't care about a hook.

If ordering is important, you can always rename your plugins to start with a number, which will define an order of
execution. A plugin author might care about when it is run, but it's up to the user to take their advice or decide
to run it in a different position in the order, by simply renaming the plugin script.

## Shell scripts aren't just Bash

Like hook scripts, plugins don't have to be implemented in Bash or any shell scripting language. They just have
to implement the protocol and define their interpreter with `#!`. 

## pluginhook implementation

You can see the implementation for this is simple. 20 lines of Bash. While this is usable, at some point
it might make sense to re-implement in C or Go with the intention of actually streaming between plugins instead
of writing to files and variables. Currently all output is buffered, which is not ideal.

## Author

Jeff Lindsay <progrium@gmail.com>

## License

MIT
