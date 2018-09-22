TEST_PROGRAMS := $(wildcard *.logo)
TEST_GRAPHICS = $(TEST_PROGRAMS:.logo=.png)
test: $(TEST_GRAPHICS)

EXE = ../_build/default/cairo/logo.exe
$(EXE):
	dune build logo.exe

%.png: %.logo $(EXE)
	$(EXE) $<
	convert $@ -trim $@

clean:
	rm -f $(TEST_GRAPHICS)
