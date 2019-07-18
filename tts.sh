#!/bin/bash
# Text to speech (speech synthesis)
# Written by Abdullah Alrajeh, July 2019
# Email: asrajeh@kacst.edu.sa

usage() { echo "usage: $0 -i <file|text> -o <file> -v <voice> [-d <1|2> ] [-vol <volume>] [-s <speed>]" 1>&2; exit 1; }
if [ $# = 0 ]; then usage; exit 1; fi
while [ "$1" != "" ]; do
  case $1 in
      -i | --input )          shift
                              input=$1
                              ;;
      -o | --output )         shift
                              output=$1
                              ;;
      -v | --voice )          shift
                              voice=$1
                              ;;
      -d | --diacritize )     shift
                              diacritize=$1
                              ;;
      -s | --speed )          shift
                              speed=$1
                              ;;
      -vol | --volume )       shift
                              volume=$1
                              ;;
      -h | --help )           usage
                              exit
                              ;;
      * )                     usage
                              exit 1
  esac
  shift
done

if [ ! -f "$input" ]; then
  echo "$input" > input;
  input=input
fi
input=`readlink -f $input`

# Preprocessing
sed -i 's/[0-9]\+/رَقَم/g' $input # currently replace numbers with word رقم

# Diacritization
if [ "$diacritize" == 1 ]; then
  cd diac_almosallam
  cat $input > input
  ./run.sh input output
  input=`pwd`/output
  cd ..
fi

if [ "$diacritize" == 2 ]; then
  cd diac_althubaity
  cat $input > input
  ./run.py input output
  input=`pwd`/output
  cd ..
fi

FLITE=`pwd`/tools/flite/bin/flite
TEXT2WAVE=`pwd`/tools/festival/bin/text2wave

if [ "$voice" == asc_flite ]; then
  FV_VOICENAME=kacst_ar_asc
  $FLITE -voice ./$FV_VOICENAME.flitevox $input $output
fi

if [ "$voice" == asc_festvox ]; then
  FV_FULLVOICENAME=kacst_ar_asc_cg
  VOICEDEF=`pwd`/tools/festival/lib/voices/ar/$FV_FULLVOICENAME/festvox/$FV_FULLVOICENAME.scm
  $TEXT2WAVE -eval $VOICEDEF -eval "(voice_$FV_FULLVOICENAME)" $input -o $output
fi

if [ "$voice" == sassc_flite ]; then
  FV_VOICENAME=kacst_ar_sassc
  $FLITE -voice ./$FV_VOICENAME.flitevox $input $output
fi

if [ "$voice" == sassc_festvox ]; then
  FV_FULLVOICENAME=kacst_ar_sassc_cg
  VOICEDEF=`pwd`/tools/festival/lib/voices/ar/$FV_FULLVOICENAME/festvox/$FV_FULLVOICENAME.scm
  $TEXT2WAVE -eval $VOICEDEF -eval "(voice_$FV_FULLVOICENAME)" $input -o $output
fi

if [ ! -z "$volume" ]; then
  sox -v $volume $output tmp000.wav
  mv tmp000.wav $output
fi

if [ ! -z "$speed" ]; then
  sox $output tmp000.wav tempo $speed
  mv tmp000.wav $output
fi
