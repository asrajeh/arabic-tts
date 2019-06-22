#!/bin/sh
# This script installs already built Arabic TTS voices
# Written by Abdullah Alrajeh, June 2019
# Email: asrajeh@kacst.edu.sa
# Reference: http://festvox.org

if [ ! -d tools ]; then
  echo 'Install FestVox voice building suite from github..'
  mkdir tools
  cd tools
  wget http://festvox.org/do_install
  # change do_install to update grapheme_unitran_tables.c in Flite
  sed -i '/cd flite/a .\/configure; cd lang\/cmu_grapheme_lex; make mapping; cd ..\/..' do_install
  sh do_install
  cd ..
fi

cd tools
tar xvzf ../festvox_kacst_ar_asc_cg.tar.gz
LANG=ar
FV_VOICENAME=kacst_ar_asc
FV_FULLVOICENAME=kacst_ar_asc_cg
VOICEDEF=`pwd`/festival/lib/voices/$LANG/$FV_FULLVOICENAME/festvox/$FV_FULLVOICENAME.scm
TEXT2WAVE=`pwd`/festival/bin/text2wave
FLITE=`pwd`/flite/bin/flite
cd ..

$TEXT2WAVE -eval $VOICEDEF -eval "(voice_$FV_FULLVOICENAME)" input.txt -o $FV_VOICENAME-festvox.wav
# change audio playback speed but not its pitch
sox $FV_VOICENAME-flite.wav $FV_VOICENAME-festvox2.wav tempo 1.1

$FLITE -voice ./$FV_VOICENAME.flitevox input.txt $FV_VOICENAME-flite.wav
# change audio playback speed but not its pitch
sox $FV_VOICENAME-flite.wav $FV_VOICENAME-flite2.wav tempo 1.1
