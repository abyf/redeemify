Add yourself as a Vendor

To log in as a vendor, comment out line where you adding yourself as a provider

To strengthen the knowledge:

create new branch
    git branch Vendor
add yourself as a vendor
  git checkout Vendor --> to switch to the new created branch
  git status --> to check unstaged files, db/seeds is unstaged coz I added myself as a vendor
  git add db/seeds --> to add myself as a vendor for the branch created
make a commit
    git commit -m "Add myself as a vendor"
merge master with the new branch
  git checkout master
  git merge vendor
rake db:reset to update database
    Note: db:reset runs db:drop db:setup
    db:setup runs db:schema:load, db:seed
    db:schema:load loads the schema into the current env's database
    db:migrate runs migrations for the current env that have not run yet
    We have to run db:migrate only once, to configure database in our
    development environment
    When we reset db, it loads the schema
run the server
log in through Google

As a result you have to be logged in as a vendor