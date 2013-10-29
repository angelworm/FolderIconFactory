#!/bin/bash

langs="English"

for lang in $langs; do
	ibtool --write $lang".lproj/MainMenu.nib" -d $lang".lproj/MainMenu.nib.strings" Japanese.lproj/MainMenu.nib
done