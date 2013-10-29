#!/bin/bash

ibtool Japanese.lproj/MainMenu.nib --generate-stringsfile Japanese.lproj/MainMenu.nib.strings
iconv -f UTF-16 -t UTF-8 Japanese.lproj/MainMenu.nib.strings | grep title > MainMenu.nib.strings
iconv -f UTF-8 -t UTF-16 MainMenu.nib.strings > Japanese.lproj/MainMenu.nib.strings 
rm MainMenu.nib.strings