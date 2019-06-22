#!/bin/sh
# This script builds grapheme-based Arabic TTS from ASC corpus
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
export FESTVOXDIR=`pwd`/festvox
export ESTDIR=`pwd`/speech_tools
export FLITEDIR=`pwd`/flite
export SPTKDIR=`pwd`/SPTK
cd ..

if [ ! -d arabic-speech-corpus ]; then
  wget http://en.arabicspeechcorpus.com/arabic-speech-corpus.zip
  unzip arabic-speech-corpus.zip
fi

WAV=`pwd`/arabic-speech-corpus/wav
TXT=`pwd`/arabic-speech-corpus/lab

if [ ! -d $WAV ] || [ ! -d $TXT  ]; then
  echo '** Please cheak if your training data exists.'
  exit 1
fi

FV_INST=kacst
FV_LANG=ar
FV_NAME=asc
FV_VOICENAME=$FV_INST"_"$FV_LANG"_"$FV_NAME

# set up a base voice
mkdir $FV_VOICENAME
cd $FV_VOICENAME
$FESTVOXDIR/src/clustergen/setup_cg $FV_INST $FV_LANG $FV_NAME

# prepare wav and txt files
for f in $WAV/*.wav; do sox "$f" `echo $f | sed 's/ /_/g'`; rm "$f"; done
for f in $TXT/*.lab; do mv "$f" `echo $f | sed 's/ /_/g'`; done
./bin/get_wavs $WAV/*.wav
ls $TXT/ | sed 's/\.lab//g' > data.1
for f in $TXT/*.lab; do cat $f; echo; done | perl ../buckwalter.pl -d=2 | sed -E 's/^|$/"/g' > data.2
paste -d' ' data.1 data.2 | sed 's/^/( /g; s/$/ )/g' > etc/txt.done.data
rm data.1 data.2

# complete  the  voice  templates
$FESTVOXDIR/src/grapheme/make_cg_grapheme

# build the prompts and label the data
./bin/do_build parallel build_prompts etc/txt.done.data
./bin/do_build label etc/txt.done.data
./bin/do_clustergen parallel build_utts etc/txt.done.data
./bin/do_clustergen generate_statenames
./bin/do_clustergen generate_filters

# feature extraction
./bin/do_clustergen parallel f0_v_sptk
./bin/do_clustergen parallel mcep_sptk
sed -i 's/cg:mixed_excitation nil/cg:mixed_excitation t/' festvox/clustergen.scm
./bin/do_clustergen parallel str_sptk
./bin/do_clustergen parallel combine_coeffs_me

# build the models
./bin/traintest etc/txt.done.data
./bin/do_clustergen parallel cluster etc/txt.done.data.train
./bin/do_clustergen dur etc/txt.done.data.train

# test - MCD less than 5 is probably good (ref http://festvox.org/cmu_wilderness/)
$FESTVOXDIR/src/clustergen/cg_test resynth cgp >mcd.out

# Build a distributable Festival voice. To include it, extract festvox_*.tar.gz in tools folder
./bin/do_clustergen festvox_dist

# generate speech sample
./bin/synthfile ../input.txt $FV_VOICENAME-festvox.wav
# change audio playback speed but not its pitch
sox $FV_VOICENAME-festvox.wav $FV_VOICENAME-festvox2.wav tempo 1.1

# conversion of FestVox voice to Flite
$FLITEDIR/tools/setup_flite
./bin/build_flite
cd flite
make
make voicedump
# generate speech sample
$FLITEDIR/bin/flite -voice ./$FV_VOICENAME.flitevox ../../input.txt $FV_VOICENAME-flite.wav
# change audio playback speed but not its pitch
sox $FV_VOICENAME-flite.wav $FV_VOICENAME-flite2.wav tempo 1.1
