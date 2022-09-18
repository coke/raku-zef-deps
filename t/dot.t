#!/usr/bin/env raku

use Test;

plan 1;

my @command = <<$*EXECUTABLE -Ilib bin/zef-deps>>;

my $out = run(|@command, '.', :out, :err).out.slurp(:close);

my $expected = q:to/OUT/;
JSON::Fast
    Test
Zef
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
Zef::Client
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
Zef::Config
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
OUT

is $out, $expected, 'META6.json dependencies';
