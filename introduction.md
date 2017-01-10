The app is already configured

To run PostgreSQL database:
sudo service postgresql start

Tasks:
1. Sync your master branch with upstream master

  When you open c9, run postgresql server first
    sudo service postgresql start
  Then switch to your master branch
    git checkout master
  Then sync your master branch with upstream master
    git pull upstream master
  You have to add a commit message
    ctrl-x to use default

Best practices:

1. Start work on new feature on new branch
2. Before every new commit run tests:
    a. rspec
    b. cucumber
3. Make commits regularly
    it is useful to learn how to manage commits

Useful git commands:

git diff
  to see differences compared to last commit

git log
  to see commits
  q to quit

git branch <new-branch>
  to create new branch

git checkout <branch>
  to switch to another branch
  
git merge <new-branch>
  Given you are on the <master> branch
  When git merge <new-branch>
  Then you will update <master> with code from <new-branch>
  If they can't be merged automatically
  Then you have to resolve conflicts
    Git will point out on files with conflicts
    Solve them and make a commit

git -A
  Add all files to your local repo

git commit -am "<message>"
  Commit style
    https://github.com/erlang/otp/wiki/Writing-good-commit-messages

git pull <remote> <branch>
  to up to date local repo
  git pull upstream master

git push origin master
  to update your remote master