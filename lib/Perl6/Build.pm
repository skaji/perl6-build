package Perl6::Build;
use strict;
use warnings;

use File::Path ();
use File::Spec;
use File::Temp ();
use Getopt::Long ();
use Perl6::Build::Builder::RakudoStar;
use Perl6::Build::Builder::Source;
use Perl6::Build::Builder;
use Pod::Text ();

sub new {
    my ($class, %args) = @_;
    my $workdir = $args{workdir} || File::Spec->catdir($ENV{HOME}, ".perl6-build");
    my $id = time . ".$$";
    bless { workdir => $workdir, id => $id }, $class;
}

sub cache_dir {
    my $self = shift;
    File::Spec->catdir($self->{workdir}, "cache");
}

sub git_reference_dir {
    my $self = shift;
    File::Spec->catdir($self->{workdir}, "git_reference");
}

sub build_dir {
    my $self = shift;
    File::Spec->catdir($self->{workdir}, "build", $self->{id});
}

sub log_file {
    my $self = shift;
    File::Spec->catfile($self->build_dir, "build.log");
}

sub run {
    my ($self, @argv) = @_;

    my @configure_option;
    my ($index) = grep { $argv[$_] eq '--' } 0..$#argv;
    if (defined $index) {
        (undef, @configure_option) = splice @argv, $index, @argv - $index;
    }

    local @ARGV = @argv;
    Getopt::Long::Configure(qw(default no_auto_abbrev no_ignore_case));
    Getopt::Long::GetOptions
        "l|list"      => \my $list,
        "L|list-all"  => \my $list_all,
        "h|help"      => \my $help,
        "w|workdir=s" => \$self->{workdir},
    or exit 1;

    if ($help) {
        $self->show_help;
        return 1;
    }

    if ($list || $list_all) {
        my $msg = $list_all ? "" : " (latest 20 versions)";
        print "Available versions$msg:\n";
        my @star = Perl6::Build::Builder::RakudoStar->available;
        my @source = Perl6::Build::Builder::Source->available;
        if ($list_all) {
            print " $_\n" for @star, @source;
        } else {
            print " $_\n" for @star[0..9], @source[0..9];
        }
        return 0;
    }

    my ($version, $prefix) = @ARGV;
    die "Invalid arguments; try `perl6-build --help` for help.\n" if !$prefix;

    File::Path::mkpath($_) for grep !-d, $self->cache_dir, $self->build_dir, $self->git_reference_dir;

    if ($version =~ /^rakudo-star-/) {
        my $star = Perl6::Build::Builder::RakudoStar->new(
            version => $version,
            cache_dir => $self->cache_dir,
            build_dir => $self->build_dir,
            log_file  => $self->log_file,
        );
        $star->fetch;
        $star->build($prefix, @configure_option);
    } else {
        my $source = Perl6::Build::Builder::Source->new(
            commitish => $version,
            build_dir => $self->build_dir,
            git_reference_dir => $self->git_reference_dir,
            log_file  => $self->log_file,
        );
        $source->fetch;
        my $describe = $source->describe;
        $prefix =~ s/\{describe\}/$describe/g;
        $source->build($prefix, @configure_option);
    }
    return 0;
}

sub show_help {
    my $self = shift;
    open my $fh, ">", \my $out;
    Pod::Text->new->parse_from_file($0, $fh);
    print "\n";
    for my $line (split /\n/, $out) {
        if ($line =~ s/^[ ]{6}//) {
            print "  $line\n";
        } elsif (!$line) {
            print "\n";
        }
    }
    print "\n";
}

1;
