package Test::Deep::URI;

use strict;
use warnings;
use 5.008_005;
our $VERSION = '0.01';

# ABSTRACT:

use base qw(Exporter::Tiny);
our @EXPORT = qw(uri);

use Test::Deep::Cmp; # exports "new", other stuff.
use URI;
use Test::Deep ();

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

    my @expected = (
        _to_hashref([ $uri->query_form ]),
        Test::Deep::methods(@methods)
    );
    my @received = (
        _to_hashref([ $got->query_form ]),
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

sub _to_hashref
{
    my $list = shift;
    my %hash;
    while (my ($key, $val) = splice(@$list, 0, 2))
    {
        if (exists $hash{$key}) {
            $hash{$key} = [ $hash{$key} ]
                unless ref $hash{$key};
            push @{$hash{$key}}, $val;
            next;
        }
        $hash{$key} = $val;
    }
    return \%hash;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Deep::URI - Blah blah blah

=head1 SYNOPSIS

  use Test::Deep::URI;

=head1 DESCRIPTION

Test::Deep::URI is

=head1 AUTHOR

Nigel Gregoire E<lt>nigelg@airg.comE<gt>

=head1 COPYRIGHT

Copyright 2016- Nigel Gregoire

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
