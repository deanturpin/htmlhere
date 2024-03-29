This is [a link](info.md) to another document.

# Travis CI - repo configuration
Create an account with your GitHub login and enable a repo to get started.
(Travis Pro appears to enable new repos by default.)

## C++11 - simple builds
If you just want to get something building quickly the default Trusty build has
clang 5 pre-installed, no need for complicated matrices.

Travis config
```YAML
script: clang++ --version
```

Travis build debug
```bash
$ clang++ --version
clang version 5.0.0 (tags/RELEASE_500/final)
```

## C++ builds
Building for clang and gcc. These could be run as separate jobs but you
then have to handle each build attempting to deploy.
```yaml
script:
  - make CXX=clang++-6.0
  - make clean
  - make CXX=g++-8
  - cppcheck --enable=all .
  - sloccount *.cpp

matrix:
  include:
    - os: linux
      addons:
        apt:
          update: true
          sources:
            - ubuntu-toolchain-r-test
            - llvm-toolchain-trusty-8.0
          packages:
            - clang++-8.0
            - g++-8
            - cppcheck
            - sloccount
```
## C++ code coverage
Create a [codecov.io](https://codecov.io/) account with your GitHub credentials
and simply push your coverage files via Travis CI using the generic upload
script as a build stage (no need to enable the repo). Build your C++ using the
gcc ```-g --coverage``` flags (which invokes gcov). Note: I've only managed to
get sensible coverage results when compiling with gcc 6.

```yaml
script:
  - bash <(curl -s https://codecov.io/bash)
```

## Branch merge
An unexpected side-effect of using Travis CI is that your branch is
automatically built as part of the merge verification.

![](branch_merge.png)

You're also offered a Codecov report for the merge.
![](code_coverage_merge_report.png)

## Deploying to GitHub Pages
In the Travis CI repo settings create a private environment variable containing
your GitHub API key, this replaces the GitHub token below (note: use hyphens
not underscores). All branches are built in Travis CI by default but in this
example on the master branch will be deployed. Deploying for the first time
will create a "gh-pages" branch and set up the username.github.io/repo static
web page. I like to use this to generate "live" READMEs containing recent data.

Create an API key in your [GitHub
settings](https://github.com/settings/tokens), tick "repo" and
"admin:public_key". "skip-cleanup" is set to true because you probably want to
deploy the things you've generated.

Finally, in your GitHub repo settings ensure the GitHub Pages section "source" is gh-pages branch.

```yaml
deploy:
  provider: pages
  github-token: ${github_token}
  skip-cleanup: true
  on:
    branch: master
```

# R with packages
```yaml
language: R
install:
  - R -e "install.packages('csv')"
  - R -e "install.packages('rjson')"
  - R -e "install.packages('rmarkdown')"

script: make
```

## bash with dot
```yaml
script: make
install: sudo apt install graphviz
```

## Python with requests
HTTP requests aren't available by default so you must instruct Travis CI to
make it so using an additional "requirements" file.

```yaml
language: python
python: "3.6"
script: make

# This is implicit
# pip install -r requirements.txt
```

Add ```requirements.txt``` file to the top level of your repo containing a list
of dependencies.
```bash
requests
```

# Linting and profiling
To use ```gprof```, compile your code with the ```-pg``` flag, run the exe and
then process the results as part of your build script.
```yaml
script:
  - make
  - ./spectrum.o
  - gprof ./spectrum.o
```

To run ```cppcheck```, add it to your apt configuration and simply run as a
build stage.
```yaml
script:
  - cppcheck --enable=all .
```

Also ```sloccount``` can be run to give an insight into the cost of your
codebase.

# Compiler options
```bash
# Standard
--std=c++2a --all-warnings --extra-warnings --pedantic-errors

# Warnings that are not included by *all* and *extra* but sound like a thing we
# want to know about
-Werror -Wshadow -Wfloat-equal -Weffc++ -Wdelete-non-virtual-dtor \
-Warray-bounds -Wattribute-alias -Wformat-overflow -Wformat-truncation \
-Wmissing-attributes -Wstringop-truncation \
-Wdeprecated-copy -Wclass-conversion \

# And a whisper of optimisation
-O1

# Profiler
-pg

# Code coverage (gcc only, ignored by clang)
-g --coverage
```
