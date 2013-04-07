#!/usr/bin/env zsh

SCRIPT_NAME=`basename $0`

# Don't run this as root. Really not meant for that.
if [[ $UID -eq 0 ]]; then
  echo "Please don't run $SCRIPT_NAME as root or under sudo."
  exit 1
fi

# Run only under zsh
if [ ! -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]
then
  cat <<EOHELP

  You must set your shell to zsh to use $SCRIPT_NAME
  You can do this via:

  chsh -s `which zsh`

EOHELP
  exit 1;
fi

CLEAR="\033[0m"
ORANGE="\033[33m"

successfully() {
  $* || (echo "failed" 1>&2 && exit 1)
}

fancy_echo() {
  echo -e ${ORANGE}$1${CLEAR}
  echo
}


fancy_echo "Checking for SSH key, generating one if it doesn't exist ..."
  [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa

fancy_echo "Copying public key to clipboard. Paste it into your Github account ..."
  [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
  successfully x-www-browser https://github.com/account/ssh


fancy_echo "Installing The Silver Searcher (better than ack or grep) for searching the contents of files ..."
  successfully git clone git://github.com/ggreer/the_silver_searcher.git /tmp/the_silver_searcher
  successfully cd /tmp/the_silver_searcher
  successfully sh build.sh
  successfully mkdir -p ~/bin/
  successfully cp /tmp/the_silver_searcher/ag ~/bin/
  successfully cd ~
  successfully rm -rf /tmp/the_silver_searcher

fancy_echo "Installing rbenv for changing Ruby versions ..."
  successfully git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
  successfully echo "export SHELL=$(which zsh)" >> ~/.zshrc
  successfully echo 'export PATH="$HOME/bin:$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  successfully echo 'eval "$(rbenv init -)"' >> ~/.zshrc
  successfully source ~/.zshrc

fancy_echo "Installing rbenv-gem-rehash so the shell automatically picks up binaries after installing gems with binaries..."
  successfully git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

fancy_echo "Installing ruby-build for installing Rubies ..."
  successfully git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

fancy_echo "Installing Ruby 1.9.3-p392 ..."
  successfully RUBY_CFLAGS="-march=native -O2" rbenv install 1.9.3-p392

fancy_echo "Setting Ruby 1.9.3-p392 as global default Ruby ..."
  successfully rbenv global 1.9.3-p392
  successfully rbenv shell 1.9.3-p392

fancy_echo "Update to latest Rubygems version ..."
  successfully gem update --system

fancy_echo "Installing critical Ruby gems for Rails development ..."
  successfully gem install bundler foreman pg rails thin --no-document

fancy_echo "Installing GitHub CLI client ..."
  successfully gem install hub --no-document

fancy_echo "Installing Heroku CLI client ..."
  successfully sh <(curl -s https://toolbelt.heroku.com/install-ubuntu.sh)

fancy_echo "Installing the heroku-config plugin for pulling config variables locally to be used as ENV variables ..."
  successfully heroku plugins:install git://github.com/ddollar/heroku-config.git

fancy_echo "Your shell will now restart in order for changes to apply."
  exec `which zsh` -l
