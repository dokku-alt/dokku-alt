
teardown() {
  rm -rf /home/git
  userdel git
}

@test "gitreceive init creates git user ready for pushes" {
  gitreceive init
  [[ -d /home/git ]]
  [[ -f /home/git/.ssh/authorized_keys ]]
  [[ -f /home/git/receiver ]]
  [[ "git" == "$(ls -l /home/git/receiver | awk '{print $3}')" ]]
}

@test "gitreceive receiver script gets tar of pushed repo" {
  gitreceive init
  cat /root/.ssh/id_rsa.pub | ssh root@localhost "gitreceive upload-key test"
  mkdir $BATS_TMPDIR/$BATS_TEST_NAME-push
  chown git $BATS_TMPDIR/$BATS_TEST_NAME-push
  cat <<EOF > /home/git/receiver
#!/bin/bash
tar -C $BATS_TMPDIR/$BATS_TEST_NAME-push -xf -
EOF
  mkdir $BATS_TMPDIR/$BATS_TEST_NAME-repo
  cd $BATS_TMPDIR/$BATS_TEST_NAME-repo
  git init
  echo "foobar" > contents
  git add .
  git commit -m 'only commit'
  git remote add test git@localhost:test-$BATS_TEST_NUMBER
  git push test master
  [[ -f $BATS_TMPDIR/$BATS_TEST_NAME-push/contents ]]
  [[ "foobar" == $(cat $BATS_TMPDIR/$BATS_TEST_NAME-push/contents) ]]
}
