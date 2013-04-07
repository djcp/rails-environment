#!/usr/bin/env zsh

# Turns out that quantal has identical ruby build-deps to wheezy, and 
# precise's are a subset of wheezy's - so we'll just use wheezy's ruby build-deps
# and can create one cross-distro deb file. Sweet!

CODENAME=$CODENAME || 'wheezy'

DEPENDS=''
for i in $(cat build-deps/singular_dependent_packages build-deps/wheezy_ruby_build_deps.txt | sort | grep -vE '^[ ]*$|^#'); 
do
  DEPENDS="${DEPENDS}, ${i}"
done

DEPENDS=${DEPENDS:2}

cat <<EOCONTROL
Package: rails-environment
Version: 1.0.0
Section: main
Priority: optional
Architecture: all
Depends: ${DEPENDS}
Maintainer: Dan Collis-Puro, thoughtbot <djcp+rails-environment@thoughtbot.com>
Homepage: http://github.com/thoughtbot/
Description: A modern ruby and ruby-on-rails dev environment
 This package depends on development libraries, daemons, and development tools commonly used by rails developers. It also includes a post-install script that installs rbenv, ruby-build, ag, and other necessary tools into your user account.

EOCONTROL
