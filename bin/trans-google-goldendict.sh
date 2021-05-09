#!/bin/bash
# This script translate English to Chinese using Google Translate.
# I use it in Goldendict. The benefit of using this script rather then using trans directly is that if there is no Englist word in the desire translate text, it'll pass the trans operation, so you won't see a blank result if you say waht thans Chinese to English.
if [ $# -eq 1 ]
then
	if [ $(echo "$1" | grep -c -i '[a-zA-z]') -gt 0 ]
	then
		/usr/local/bin/trans -e google -s en -t zh-CN -show-original y -show-original-phonetics n -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages n -show-original-dictionary n -show-dictionary n -show-alternatives n "$1"
	fi
fi
