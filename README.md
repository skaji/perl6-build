# perl6 build

Build perl6 from rakudo-star tarballs or rakudo git repository

```console
Usage:
 $ perl6-build [options] VERSION   PREFIX [-- [configure options]]
 $ perl6-build [options] COMMITISH PREFIX [-- [configure options]]

Options:
 -h, --help      show this help
 -l, --list      list available versions (latest 20 versions)
 -L, --list-all  list all available versions
 -w, --workdir   set working directory, default: ~/.perl6-build

Example:
 # List available versions
 $ perl6-build -l

 # Build and install rakudo-star-2018.04 to ~/perl6
 $ perl6-build rakudo-star-2018.04 ~/perl6

 # Build and install rakudo git repository (with 2018.06 tag) to ~/perl6
 $ perl6-build 2018.06 ~/perl6

 # Build and install rakudo git repository (with HEAD) to ~/perl6-{describe}
 # where {describe} will be replaced by `git describe` such as `2018.06-259-g72c8cf68c`
 $ perl6-build HEAD ~/perl6-'{describe}'

 # Build and install rakudo git repository with jvm backend
 # Note that configure options must be specified after '--'
 $ perl6-build HEAD ~/jvm-'{describe}' -- --backends jvm --gen-nqp
```

## Install

```console
wget https://raw.githubusercontent.com/skaji/perl6-build/master/bin/perl6-build
chmod +x perl6-build
./perl6-build --help
```

## Author

Shoichi Kaji

## License

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

Please note that [bin/perl6-build](bin/perl6-build) embeds the following distributions, and they have their own licenses:

* [File-Which](https://metacpan.org/release/)
* [File-pushd](https://metacpan.org/release/File-pushd)
* [HTTP-Tiny](https://metacpan.org/release/HTTP-Tiny)
* [HTTP-Tinyish](https://metacpan.org/release/HTTP-Tinyish)
* [IPC-Run3](https://metacpan.org/release/IPC-Run3)
* [parent](https://metacpan.org/release/parent)
