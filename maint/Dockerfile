FROM perl:latest

RUN curl --compressed -fsSL https://git.io/cpm | perl - install -g App::cpm App::FatPacker::Simple
WORKDIR /perl6-build/maint
CMD ["make", "clean", "fatpack"]
