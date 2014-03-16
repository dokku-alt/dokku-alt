#!/usr/bin/env bats

@test "filter pipelining" {
  result=$(echo Hello world | $BIN text)
  [[ $result == "DLROW OLLEH" ]]
}

@test "run all plugins with hook" {
  result=$($BIN pre-build | wc -l)
  [[ $result -eq 2 ]]
}

@test "run tests in series" {
  times=( $($BIN time) )
  [[ $(( ${times[0]} - ${times[1]} )) -ge 2 ]]
}

@test "run tests in parallel" {
  times=( $($BIN -p time) )
  [[ $(( ${times[0]} - ${times[1]} )) -le 1 ]]
}

@test "print trace of hook calls" {
  stderr=$(echo Hello | $BIN -x cat 2>&1 >/dev/null)
  [[ $stderr == +* ]]
  stderr=$(echo Hello | $BIN -x -p cat 2>&1 >/dev/null)
  [[ $stderr == +* ]]
  stderr=$(echo Hello | PLUGINHOOK_TRACE=1 $BIN cat 2>&1 >/dev/null)
  [[ $stderr == +* ]]
  stderr=$(echo Hello | PLUGINHOOK_TRACE=1 $BIN -p cat 2>&1 >/dev/null)
  [[ $stderr == +* ]]
}

