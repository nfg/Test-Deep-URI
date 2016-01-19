use strict;
use warnings;
package Test::Deep::URI;

# ABSTRACT: 

use base qw(Exporter::Tiny);
our @EXPORT = qw(uri);

use Test::Deep::Cmp; # exports "new", other stuff.
use URI;
use Hash::MultiValue;
use Test::Deep ();
use Data::Printer return_value => 'dump';

my %valid_keys = map { $_ => 1 } qw(path fragment scheme query_form);

sub uri { __PACKAGE__->new(@_); }

sub init
{
    my ($self, $args) = @_;

    my $tests;
    if (ref $args) {
        foreach my $key (keys %valid_keys) {
            next unless exists $args->{$key};
            $self->{$key} = $args->{$key};
        }

        foreach my $mode (qw(as_hashref as_hashref_mixed as_hashref_multi)) {
            if ($args->{$mode})
            {
                warn qq(Overwriting "query_form" due to key "$mode")
                    if exists $self->{qfmode};

                $self->{query_form} = $args->{$mode};
                $self->{qfmode} = $mode;
            }
        }
    }
    else {
        $self->{uri} = URI->new($args);
    }
}

sub descend
{
    my ($self, $got) = @_;

    my $tests;

    if ($self->{uri}) {
        my $uri = $self->{uri};
        my @methods;
        push @methods, scheme => $uri->scheme if $uri->has_recognized_scheme();
        local $@;
        eval { push @methods, host => $uri->host }; # Dies on partial URIs
        push @methods, path => $uri->path;
        push @methods, fragment => $uri->fragment;

        $tests = Test::Deep::methods(@methods);
#        Test::Deep::all(
#            query_form => Test::Deep::code(sub {
#                    my $data = shift;
#                    print "DATA IS " . np($data);
#
#                    return 1;
#                })
#            );
    }

    $got = URI->new($got);
    $self->data->{got} = $got;
    return Test::Deep::wrap($tests)->descend($got);
}
#    my ($path, $args, $name) = @_;
#    local $Test::Builder::Level = $Test::Builder::Level + 1;
#    note "URI: $Lib::KM::_test_query";
#
#    my $uri = URI->new($Lib::KM::_test_query);
#    my $found = [ $uri, { $uri->query_form } ];
#    my $tests = [ methods( path => $path ), $args ];
#    cmp_deeply($found, $tests, $name);
#}

sub diagnostics
{
    my $self = shift;
    return "BOOGER";
}
1;
