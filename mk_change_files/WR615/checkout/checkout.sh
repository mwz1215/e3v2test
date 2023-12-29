#!/bin/bash

rm -f scripts/mtkwifi.py
git checkout target/linux/ramips/mt7621/config-4.4
git checkout target/linux/ramips/Makefile
git checkout include/kernel-defaults.mk
