#!/usr/bin/env bats

@test "filter pipelining" {
  result=$(echo Hello world | $BIN text)
  [[ $result == "DLROW OLLEH" ]]
}

@test "run all plugins with hook" {
  result=$($BIN pre-build | wc -l)
  [[ $result -eq 2 ]]
}
