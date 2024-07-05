[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

# Math::Vector

This is a fork of https://github.com/colomon/Math-Vector from v0.6.0

## SYNOPSIS

```raku
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
```

