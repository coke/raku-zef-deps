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

is $out, $expected.chomp, 'zef dependencies as json';
