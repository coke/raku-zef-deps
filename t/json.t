#!/usr/bin/env raku

use Test;

plan 1;

my @command = <<$*EXECUTABLE -Ilib bin/zef-deps --json>>;

my $out = run(|@command, 'zef', :out, :err).out.slurp(:close);

my $expected = q:to/OUT/;
[
  {
    "deps": [
      {
        "name": "NativeCall",
        "ver": "6.c+"
      },
      {
        "name": "Test",
        "ver": "6.c+"
      }
    ],
    "name": "zef"
  }
]
OUT

is $out, $expected, 'zef dependencies as json';
