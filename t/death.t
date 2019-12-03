#!/usr/bin/env perl
use Test::More;

TODO: {
    local $TODO = 'It is OK';
    fail 'YARR';

    fail 'mroe yarr';
}

pass 'yarr';

done_testing();
