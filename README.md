# NAME

Test::Deep::URI - Easier testing of URIs for Test::Deep

# SYNOPSIS

    use Test::Deep;
    use Test::Deep::URI;

    $testing_url = "http://site.com/path?a=1&b=2";
    cmp_deeply(
      $testing_url,
      all(
        uri("http://site.com/path?a=1&b=2"),
        # or
        uri("//site.com/path?a=1&b=2"),
        # or
        uri("/path?b=2&a=1"),
      )
    );

# DESCRIPTION

Test::Deep::URI provides the function `uri($expected)` for [Test::Deep](https://metacpan.org/pod/Test::Deep).
Use it in combination with `cmp_deeply` to test against partial URIs.

In particular I wrote this because I was tired of stumbling across unit
tests that failed because `http://site.com/?foo=1&bar=2` didn't match
`http://site.com/?bar=2&foo=1`. This helper is smart enough to compare
query\_form parameters separately, while still enforcing the order of values
for duplicate parameters.

# FUNCTIONS

- uri($expected)

    Exported by default.

    _$expected_ should be a string that can be passed to `URI-`new()>.

# ERRATA

I've mostly been using this with URLs, but it's built around [URI](https://metacpan.org/pod/URI)
and should work with all types. Let me know if something doesn't work.

# AUTHOR

Nigel Gregoire &lt;nigelg@airg.com>

# COPYRIGHT

Copyright 2016 - Nigel Gregoire

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

- [Test::Deep](https://metacpan.org/pod/Test::Deep)
- [Test::Deep::JSON](https://metacpan.org/pod/Test::Deep::JSON)
