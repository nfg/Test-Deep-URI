# vim: set ft=perl
use strict;
use warnings;

use Test::More;
use Test::Warnings;
use Test::Deep;
use Test::Deep::URI;

use URI;

cmp_deeply(
    'http://everythingis.awesome/stuffinpath/andso?a=1&a=2&a=3&b=the final countdown#hola',
    uri({
            scheme => 'http',
            host => 'everythingis.awesome',
            path => '/stuffinpath/andso',
            fragment => 'hola',
            query_form => {
                a => [1,2,3],
                b => 'the final countdown'
            },
        }),
    "Works on a complicated example."
);

cmp_deeply(
    '//whatever.com/testpath',
    uri({
            path => '/testpath',
            scheme => undef,
        }),
    'Functions without scheme',
);

cmp_deeply(
    'http://testing/?a=1&b=2',
    uri('http://testing/?b=2&a=1'),
    'Can be used with a simple string'
);

cmp_deeply(
    'http://testing/?a=1&b=2',
    all(
        uri('//testing/?b=2&a=1'),
        uri('/?b=2&a=1'),
        uri({ path => '/' }),
        uri({ query_form => { a => 1, b => 2 } }),
    ),
    'Testing simpler, shorter uris',
);

#cmp_deeply(
#    '/method?a=1&a=2&a=3&b=4&a=5',
#    uri({
#            query_form => [ 'a' => 1
#


done_testing();
