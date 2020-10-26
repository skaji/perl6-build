FROM perl:latest

RUN curl --compressed -sSL https://git.io/cpm -o /usr/local/bin/cpm
RUN chmod +x /usr/local/bin/cpm
RUN cpm install -g App::FatPacker::Simple
WORKDIR /p6-build/maint
CMD ["make", "fatpack"]
