#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

%*ENV<ZEF_DEPS_INDENT>=10;

my $out = MAIN-handler(['zef',]);

my $expected = q:to/OUT/;
zef
          NativeCall:ver<6.c+>
          Test:ver<6.c+>
OUT

is $out, $expected, 'zef dependencies, indented';
