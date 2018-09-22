# A Logo Interperter in Ocaml (and JavaScript)

![A tree created in Logo](http://chrisma.es/logoturtle/samples/tree2.png)

## Try  the interperter in your browser

Visit http://cmaes.github.io/logoturtle/

See [this page](http://cmaes.github.io/logoturtle/samples) for sample
programs and their graphical output.

## Installation

The following directions describe how to install the dependencies for
running the code locally.

### Install OCaml

Use the Real World OCaml installation instructions
https://github.com/realworldocaml/book/wiki/Installation-Instructions

#### On Linux

```
sudo add-apt-repository ppa:avsm/ppa
sudo apt-get update
sudo apt-get install curl build-essential m4 ocaml opam
```

Then do
```
opam init
eval `opam config env`
```

#### On Mac

Install Homebrew http://brew.sh.

```
brew install ocaml
brew install opam
```

Then do
```
opam init
eval `opam config env`
```

## Build

You may need something like `libcairo2-dev` to produce .png files:
```
opam pin add logoturtle-cairo .
```

The JavaScript canvas-based backend provides an `interpretLOGO` function.
An index file in ocamlfind's `share` shows how this library may be used.
```
opam pin add logoturtle-web .
```

## Run

To produce a .png file:
```
logo samples/tree.logo
```

To test the interpreter in your browser:
```shell
xdg-open `opam config var share`/logoturtle-web #Linux
open `opam config var share`/logoturtle-web #Mac
```


#### Logo Grammar

I made my own up. But there is one [here](https://www.cs.duke.edu/courses/spring00/cps108/projects/slogo/slogo.g)
