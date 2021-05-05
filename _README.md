# Package Title

This [MLHub](https://mlhub.ai) package ... 

The source code for the package is available from
<https://github.com/gjwgit/pkg>.

## Quick Start

```console
$ ml adult       pkg <file.jpg>  # Does image contain questionable material.
$ ml brands      pkg
$ ml category    pkg
$ ml celebrities pkg
$ ml color       pkg <file.jpg>  # Colorize a (black and white) photo.
$ ml describe    pkg
$ ml faces       pkg
$ ml geocode     pkg
$ ml identify    pkg <file.png>  # Identify onjects in a photo.
$ ml landmarks   pkg
$ ml objects     pkg
$ ml ocr         pkg <file.jpg>  # Optical character recognition.
$ ml predict     pkg
$ ml sentiment   pkg <sentences> # Sentiment of a sentence.
$ ml synthesize  pkg <file.wav>  # Synthesize speech from text.
$ ml tags        pkg
$ ml thumbnail   pkg <file.png>  # Create an effective thumbnail for the image.
$ ml train       pkg <file.csv>  # Train a model based on new data.
$ ml transcribe  pkg             # Transcribe audio from the microphone.
```

## Usage

- To install mlhub (Ubuntu):

		$ pip3 install mlhub
		$ ml configure

- To install, configure, and run the demo:

		$ ml install   pkg
		$ ml configure pkg
		$ ml readme    pkg
		$ ml commands  pkg
		$ ml demo      pkg
		
- Command line tools:

```console
$ ml cmd pkg [options] [argument]
     -b            --bing               Generate Bing Maps URL.
     -i <file.txt> --input=<file.txt> 	Input data.
     -g            --google             Generate Google Maps URL.
     -l <lang>     --lang=<lang>        Target language.
     -m <int>      --max=<int> 	        Maximum number of matches.
     -o            --osm                Generate Open Street Map URL.
     -o <file.wav> --output=<file.wav>  Save audio to file.
     -u            --url                Generate Open Street Map URL.
     -v <voice>    --voice=<voice>      Selected voice.
```

## Command Line Tools

In addition to the *demo* command below, the package provides a number
of useful command line tools.

### *cmd*

The *cmd* command ...

```console
$ ml cmd pkg 
```

## Demonstration

```console
===
Pkg
===

Welcome to Pkg ...

Press Enter to continue: 

===
CMD
===

Now ...

```
