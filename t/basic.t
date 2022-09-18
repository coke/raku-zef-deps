#!/usr/bin/env raku

use Test;

plan 1;

my @command = <<$*EXECUTABLE -Ilib bin/zef-deps>>;

my $out = run(|@command, 'zef', :out, :err).out.slurp(:close);

my $expected = q:to/OUT/;
zef
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
OUT

is $out, $expected, 'zef dependencies';
