#!/usr/bin/env raku
use Math::Vector;

my $v1 = Math::Vector.new(1, 2, 3);
my $v2 = Math::Vector.new(3, 4, 0);

say "My vector $v1 has {$v1.dim} dimensions";     #^(1, 2, 3)

say ~ ($v1 + $v2);         #^(4, 6, 3)
say ~ ($v1 * 2);           #^(2, 4, 6)
say ~ ($v1 ⋅ $v2);         #11
say ~ ($v1 × $v2);         #^(-12, 9, -2)
say ~ (⎡$v1⎤);             #3.7416573867739413
say ~ (-$v1);              #^(-1, -2, -3)
say ~ ($v1 cmp $v2);       #Less


