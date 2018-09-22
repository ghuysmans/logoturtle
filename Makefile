all: logo.exe logo.js
logo.exe:
	dune build cairo/logo.exe
logo.js:
	#FIXME?
	dune build logoturtle-web.install
	dune install logoturtle-web
clean:
	dune clean
