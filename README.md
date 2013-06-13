# sshcommand

Creates a system user made for running a single command via SSH and manages an ACL of SSH keys (authorized_keys).

## Commands

    $ sshcommand create <user> <command>        # creates a user forced to run command when SSH connects
    $ sshcommand acl-add <user> <name>          # adds named SSH key to user from STDIN
    $ sshcommand acl-remove <user> <name>       # removes SSH key by name
    $ sshcommand help                           # displays the usage help message


## Example

On a server, create a new command user:

    $ sshcommand create cmd /path/to/command

On your computer, add to ACL with your key:

    $ cat ~/.ssh/id_rsa.pub | ssh root@server sshcommand acl-add cmd progrium
    
Now anywhere with the private key you can easily run:

    $ ssh cmd@server
    
Anything you pass as the command string will be appended to the command. You can use this
to pass arguments or if your command takes subcommands, expose those subcommands easily.

    $ /path/to/command subcommand 
    
Can be run remotely with:

    $ ssh cmd@server subcommand
