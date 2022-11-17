#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 2;

my $out = MAIN-handler(['zef',], :png);

my $expected = q:to/OUT/;
zef
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
OUT

nok $out.contains("\n"), "single line of text";
ok $out.ends-with('.png'), "that looks like a PNG";
