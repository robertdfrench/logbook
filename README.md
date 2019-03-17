# Git-based Journal Editor
* Commit messages tell a linear story
* Directories represent todos
  * Each directory contains a `README.md` and 0 or more subdirectories
* Subdirectories represent blocking tasks
  * *Makes sure the rabbit hole has a filesystem representation*

### Usage
* `make new target=project`
* `make new target=project/subproject`
* `make clean view`

### Installation

##### clone this repo somewhere safe
```bash
git clone git@github.com:robertdfrench/logbook.git ~/.logbook
```

##### create a new git repo for your journal
```bash
mkdir journal
cd journal
git init
```

##### Symlink all the logbook software into your journal
```bash
ln -sf ~/.logbook .
git add .
git commit -m "Support journaling and todos via logbook"
```
