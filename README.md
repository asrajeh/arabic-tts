# Arabic TTS ( الناطق العربي )
This is [Festvox](http://www.festvox.org) voice trained on [Arabic Speech Corpus](http://en.arabicspeechcorpus.com)

Note that training on high quality corpus like [SASSC](https://www.isca-speech.org/archive/ssw8/ssw8_249.html) would give better results (samples included).

## Audio Samples
ASC corpus: [Festvox sample1](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-festvox.wav), [Festvox sample2](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-festvox2.wav), [Flite sample1](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-flite.wav) and [Flite sample2](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_asc-flite2.wav)

SASSC corpus: [Festvox sample](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_sassc-festvox.wav), [Festvox sample](https://github.com/asrajeh/arabic-tts/blob/master/samples/kacst_ar_sassc-flite.wav)
 
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
