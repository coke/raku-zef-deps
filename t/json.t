#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

my $out = MAIN-handler(['zef',], :json);

my $expected = q:to/OUT/;
[
  {
    "deps": [
      {
        "from": "Raku",
        "name": "NativeCall",
        "ver": "6.c+"
      },
      {
        "from": "Raku",
        "name": "Test",
        "ver": "6.c+"
      }
    ],
    "from": "Raku",
    "name": "zef"
  }
]
OUT

is $out, $expected.chomp, 'zef dependencies as json';
