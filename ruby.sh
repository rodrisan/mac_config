#!/bin/bash

## Install and configure various versions of Ruby.


source 'homebrew.sh'


## Ruby (various versions)

# Install various versions of Ruby.
brew install ruby-install
brew update
brew upgrade ruby-install
ruby-install ruby 1.9.3
ruby-install ruby 2.0.0-p648 --sha1 504be2eae6cdfe93aa7ed02ec55e35043d067ad5
ruby-install ruby 2.1.10 --sha1 22dcd759d8cbb14c8735988fbc7ee5c35f9d4720
ruby-install ruby 2.2.5 --sha1 f78473fe60a632b778599374ae64612592c2c9c1
ruby-install ruby 2.3.1 --sha1 4ee76c7c1b12d5c5b0245fc71595c5635d2217c9
ruby-install rbx 3.21
ruby-install jruby 1.7

# If you need Ruby 1.9.3-p125:
#brew install gcc46
#ruby-install ruby 1.9.3-p125 -- CC=gcc-4.6
#brew uninstall gcc46 gmp4 mpfr2 libmpc08 ppl011 cloog-ppl015


## Chruby (for switching between Ruby versions)

# We'll use chruby to allow us to easily switch between various versions of Ruby.
brew install chruby

# Allow this shell to use chruby automatically.
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Ensure new bash shells use chruby automatically.
grep -q 'chruby' ~/.bashrc || cat >> ~/.bashrc <<'EOF'

# Use chruby automatically.
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Set a default Ruby version. FIXME/TODO: Should probably just create a ~/.ruby-version file.
chruby 2.3
EOF


## Gems

# Install some gems for every version of Ruby. These are either for irb or for the commands they provide,
GEMS_TO_INSTALL='bundler awesome_print hirb wirble pry railties rubocop'
ALL_RUBY_VERSIONS=$(chruby | sed -e 's/*//' | awk '{print $1}')
CURRENT_RUBY_VERSION=$(chruby | grep '*' | awk '{print $2}' | tr -d '\n')
if [[ -z "$CURRENT_RUBY_VERSION" ]]; then
    CURRENT_RUBY_VERSION=system
fi
for ruby_version in $ALL_RUBY_VERSIONS ; do
    chruby $ruby_version
    echo "Installing gems into $ruby_version: $GEMS_TO_INSTALL"
    gem update --system
    gem update bundler
    gem install $GEMS_TO_INSTALL
done
chruby $CURRENT_RUBY_VERSION


# Install some gems for ONLY the latest Ruby.
gem install kramdown
gem install rsense
gem install ruby-beautify
brew cask install wkhtmltopdf
gem install middleman middleman-presentation
npm install -g bower # Needed by Middleman-Presentation
