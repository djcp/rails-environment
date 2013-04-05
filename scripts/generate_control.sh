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
Version: 0.1.0
Section: main
Priority: optional
Architecture: all
Depends: ${DEPENDS}
Installed-Size:
Maintainer: Dan Collis-Puro, thoughtbot 
Description: Packages needed for modern ruby development
 This metapackage depends on development libraries, daemons, and development tools
 commonly used by ruby developers.

EOCONTROL
