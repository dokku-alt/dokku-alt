package main

import (
	"os"
	"fmt"
	"os/exec"
	"syscall"
	"path/filepath"
	"log"
	"flag"
	"bytes"
	"strings"
	"code.google.com/p/go.crypto/ssh/terminal"
)

func main() {
	var parallel = flag.Bool("p", false, "Run hooks in parallel")
	var trace = flag.Bool("x", false, "Trace mode")
	flag.Parse()

	if len(os.Getenv("PLUGINHOOK_TRACE")) > 0 {
		*trace = true
	}

	pluginPath := os.Getenv("PLUGIN_PATH")
	if pluginPath == "" {
		log.Fatal("[ERROR] Unable to locate plugins: set $PLUGIN_PATH\n")
		os.Exit(1)
	}
	if flag.NArg() < 1 {
		log.Fatal("[ERROR] Hook name argument is required\n")
		os.Exit(1)
	}
	cmds := make([]exec.Cmd, 0)
	var matches, _ = filepath.Glob(fmt.Sprintf("%s/*/%s", pluginPath, flag.Arg(0)))
	for _, hook := range matches {
		cmd := exec.Command(hook, flag.Args()[1:]...)
		cmds = append(cmds, *cmd)
	}
	for i := len(cmds)-1; i >= 0; i-- {
		cmds[i].Stderr = os.Stderr

		if i == len(cmds)-1 {
			cmds[i].Stdout = os.Stdout
		}
		if i > 0 {
			if *parallel {
				stdout, err := cmds[i-1].StdoutPipe()
				if err != nil {
					log.Fatal(err)
				}
				cmds[i].Stdin = stdout
			} else {
				var buf bytes.Buffer
				cmds[i-1].Stdout = &buf
				cmds[i].Stdin = &buf
			}
		}
		if i == 0 && !terminal.IsTerminal(syscall.Stdin) {
			cmds[i].Stdin = os.Stdin
		}
	}

	if *parallel {
		done := make(chan bool, len(cmds))

		for i := 0; i < len(cmds); i++ {
			go func(cmd exec.Cmd) {
				if *trace {
					fmt.Fprintln(os.Stderr, "+", strings.Join(cmds[i].Args, " "))
				}
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
	} else {
		for i := 0; i < len(cmds); i++ {
			if *trace {
				fmt.Fprintln(os.Stderr, "+", strings.Join(cmds[i].Args, " "))
			}
			err := cmds[i].Run()
			if msg, ok := err.(*exec.ExitError); ok { // there is error code 
				os.Exit(msg.Sys().(syscall.WaitStatus).ExitStatus())
			}
		}
	}
}
