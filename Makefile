vcs=vcs -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed
all: comp sim wave

comp:
	$(vcs) -f files.f -l readme.log -timescale=1ns/1ns +v2k -debug_all

sim:
	./simv -l run.log

wave:
	./simv -gui
