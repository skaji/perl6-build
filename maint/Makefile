.PHONY: fatpack local

fatpack:local
	fatpack-simple ../script/perl6-build -d ../lib,local -o ../bin/perl6-build --shebang '#!/usr/bin/env perl'

local:
	cpm install --target-perl 5.10.1 --cpanfile ../cpanfile
