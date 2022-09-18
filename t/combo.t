#!/usr/bin/env raku

use Test;

plan 1;

my @command = <<$*EXECUTABLE -Ilib bin/zef-deps>>;

my $out = run(|@command, 'Zef::Client', 'Zef::Config', :out, :err).out.slurp(:close);

my $expected = q:to/OUT/;
Zef::Client
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
Zef::Config
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
OUT

is $out, $expected, 'Zef:C... dependencies';
