fatpack: local
	fatpack-simple script/perl6-build -o bin/perl6-build --shebang '#!/usr/bin/env perl'
	chmod +x bin/perl6-build

local:
	cpm install --target-perl 5.8.1


