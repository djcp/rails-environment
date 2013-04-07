#!/usr/bin/env zsh

./scripts/generate_control.sh > rails-environment/DEBIAN/control

dpkg --build rails-environment

rm rails-environment/DEBIAN/control
