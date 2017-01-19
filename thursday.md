Switch to redeemify folder
Check whether you have uncommited changes
git diff   nothing appeared after entering this command
Check for the updates    error: fatal: Couldn't find remote ref updates
sudo service postgresql start
git pull upstream master
They should be
I've ran command. It works, but pointing out on conflicts


error: Pull is not possible because you have unmerged files.
hint: Fix them up in the work tree, and then use 'git add/rm <file>'
hint: as appropriate to mark resolution and make a commit.
fatal: Exiting because of an unresolved conflict.

We have different messages.
Ok. Let me resolve conflicts.
Or we can do it together.
Conflicts in two files:
* db/seeds.rb
    At the bottom you'll see two choices
    HEAD is yours changes
    Other (with commit id) from the upstream master
    Keep yours changes
* config/environment/development.rb
Open the first file

You have code on the master branch
You want to pull updates from the remote
It compares all files on the remote branch with the files on your branch ok
If it finds different implementation of the same block of code, it provides a choice
You have to choose which version you want to keep
It is a conflict. And you have to resolve it.
In log files there is a list of files where you have to solve conflicts
In our case
CONFLICT (content): Merge conflict in db/seeds.rb
Auto-merging config/environments/development.rb
CONFLICT (content): Merge conflict in config/environments/development.rb
Automatic merge failed; fix conflicts and then commit the result.

We've fixed first conflict.
Now open the second file
config/environments/development.rb


