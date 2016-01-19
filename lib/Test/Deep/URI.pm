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
    my ($self, $uri) = @_;
    warn "Missing arguement to uri()!" unless defined $uri;
    # URI objects act a little weird on URIs like "//host/path".
    # "/path" can be pulled via path(), but host() dies. Thus I'm
    # copying the host string if necessary.
    if (($uri || '') =~ m{//([^/]+)/}) {
        $self->{host} = $1;
    }
    $self->{uri} = URI->new($uri);
}

sub descend
{
    my ($self, $got) = @_;

    my $uri = $self->{uri};
    $got = URI->new($got);

    my @methods;
    push @methods, scheme   => $uri->scheme if $uri->scheme();
    local $@;
    eval {
        # Dies on partial URIs
        push @methods, host => $uri->host;
        # Don't need kludge
        delete $self->{host};
    };
    push @methods, path     => $uri->path;
    push @methods, fragment => $uri->fragment;

    my $received_query_form = Hash::MultiValue->new( $got->query_form )->as_hashref_mixed;

    my @expected = (
        Hash::MultiValue->new( $uri->query_form )->as_hashref_mixed,
        Test::Deep::methods(@methods)
    );
    my @received = (
        Hash::MultiValue->new( $got->query_form )->as_hashref_mixed,
        $got,
    );

    # Kludge to test host!
    if ($self->{host}) {
        push @expected, $self->{host};
        push @received, $got->host;
    }

    $self->data->{got} = $got;
    return Test::Deep::wrap(\@expected)->descend(\@received);
}

1;
