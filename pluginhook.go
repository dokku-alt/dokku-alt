package main

import (
	"os"
	"fmt"
	"os/exec"
	"syscall"
	"path/filepath"
	"log"
	"code.google.com/p/go.crypto/ssh/terminal"
)

func main() {
	pluginPath := os.Getenv("PLUGIN_PATH") 
	if pluginPath == "" {
		log.Fatal("[ERROR] Unable to locate plugins: set $PLUGIN_PATH\n")
		os.Exit(1)
	}
	cmds := make([]exec.Cmd, 0)
	var matches, _ = filepath.Glob(fmt.Sprintf("%s/*", pluginPath))
	for _, plugin := range matches {
		hook := fmt.Sprintf("%s/%s", plugin, os.Args[1])
		if _, err := os.Stat(hook); err == nil {
			cmd := exec.Command(hook, os.Args[2:]...)
			cmds = append(cmds, *cmd)
		}
	}
	done := make(chan bool, len(cmds))
	for i := len(cmds)-1; i >= 0; i-- {
		if i == len(cmds)-1 {
			cmds[i].Stdout = os.Stdout
		} 
		if i > 0 {
			stdout, err := cmds[i-1].StdoutPipe()
			if err != nil {
				log.Fatal(err)
			}
			cmds[i].Stdin = stdout
		}
		if i == 0 && !terminal.IsTerminal(syscall.Stdin) {
			cmds[i].Stdin = os.Stdin
		}
		go func(cmd exec.Cmd) {
			err := cmd.Run()
			if msg, ok := err.(*exec.ExitError); ok { // there is error code 
				os.Exit(msg.Sys().(syscall.WaitStatus).ExitStatus())
			}
			done <- true
		}(cmds[i])
	}
	for i := 0; i < len(cmds); i++ {
		<-done
	}
}