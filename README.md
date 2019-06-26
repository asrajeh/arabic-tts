# Arabic TTS ( الناطق العربي )
This is [Festvox](http://www.festvox.org) voice trained on [Arabic Speech Corpus](http://en.arabicspeechcorpus.com)

## Audio Samples
Festvox voice: [sample1](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-festvox.wav) and [sample2](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-festvox2.wav)

Flite voice: [sample1](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-flite.wav) and [sample2](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-flite2.wav)

## On fresh Ubuntu 18
```
sudo apt install build-essential
sudo apt install git
sudo apt install sox
sudo apt install libcurses-ocaml-dev
git clone https://github.com/asrajeh/arabic-tts.git
cd arabic-tts
```

## Install
```
./install_asc_voice.sh
```

## Build from scratch
```
./build_asc_voice.sh
```
