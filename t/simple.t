# vim: set ft=perl
use strict;
use warnings;

use Test::Tester;

use Test::More;
use Test::Warnings;
use Test::Deep;
use Test::Deep::URI;

cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awesome/yarr?a=1#yarr'),
    "OK, it works"
);

subtest 'cmp failure (wrong cgi params)' => sub {
    check_test sub {
        cmp_deeply(
            'http://everythingis.awesome/yarr?a=1#yarr',
#            uri('http://everythingis.awesome/yarr?a=2#yarr'),
            uri('http://zzzeverythingis.awesome/yarr?a=2#yarr'),
        );
    }, {
        ok => 0,
        diag => <<EOTXT
Compared \$data
   got : 'everythingis.awesome'
expect : 'zzzeverythingis.awesome'
EOTXT
    };
};

done_testing();

exit;

cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('https://everythingis.awesome/yarr?a=1#yarr'),
    "flags wrong scheme",
);
cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.aweszome/yarr?a=1#yarr'),
    "flags wrong host",
);
cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awezome/yrr?a=1#yarr'),
    "flags wrong path",
);
cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awezome/yarr?a=1#rr'),
    "flags wrong fragment",
);
cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awesome/yarr#yarr'),
    "flags missing parameter",
);

cmp_deeply(
    '//everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awesome/yarr?a=1#yarr'),
    "flags missing scheme",
);

cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awesome?a=1#yarr'),
    "flags missing path",
);

cmp_deeply(
    'http://everythingis.awesome/yarr?a=1#yarr',
    uri('http://everythingis.awesome/yarr?a=1'),
    "flags missing fragment",
);

done_testing();
