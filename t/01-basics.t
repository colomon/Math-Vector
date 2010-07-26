use v6;
use Vector;
use Test;

plan *;

my $v1 = Vector.new(1, 2, 3);
my Vector $v2 = Vector.new(3, 4, 0);
my @v3 = (-1, 0, 2);
my Vector $v3 = Vector.new(@v3);
my Vector $origin3d = Vector.new(0, 0, 0);
my Vector $v5 = Vector.new(1,2,3,4,5);
my Vector $v6 = Vector.new(0,0,1,0,0);
my Vector $v7 = Vector.new(1,0,0,0,0,0,0);
my Vector $v8 = Vector.new(0,1,0,0,0,0,0);
my Vector $v9 = Vector.new(1..7);
my Vector $v10 = Vector.new(10,20,1,10,20,10,30);
my Vector $vcrazy = Vector.new(Vector.new(1, 2, 3), Vector.new(-1, 0, -1));

my @vectors = ($v1, $v2, $v3, $origin3d, $v5, $v6, $v7, $v8, $v9, $v10);

isa_ok($v1, Vector, "Variable is of type Vector");
isa_ok($v2, Vector, "Variable is of type Vector");
isa_ok($v3, Vector, "Variable is of type Vector");
isa_ok($v5, Vector, "Variable is of type Vector");
isa_ok($v7, Vector, "Variable is of type Vector");
isa_ok($vcrazy, Vector, "Variable is of type Vector");

is(~$v1, "(1, 2, 3)", "Stringify works");
is(~$v3, "(-1, 0, 2)", "Stringify works");
is(~$origin3d, "(0, 0, 0)", "Stringify works");
is(~$v5, "(1, 2, 3, 4, 5)", "Stringify works");
is(~$vcrazy, "((1, 2, 3), (-1, 0, -1))", "Stringify works");

is(~eval($v1.perl), ~$v1, ".perl works");
is(~eval($v9.perl), ~$v9, ".perl works");
is(~eval($vcrazy.perl), ~$vcrazy, ".perl works");

is($v1.Dim, 3, "Dim works for 3D Vector");
is($v5.Dim, 5, "Dim works for 5D Vector");
is($v7.Dim, 7, "Dim works for 7D Vector");

is_approx($v7 ⋅ $v8, 0, "Perpendicular vectors have 0 dot product");


#basic math tests
is(~($v1 + $v2), "(4, 6, 3)", "Basic sum works");
is(~($v7 + $v9), "(2, 2, 3, 4, 5, 6, 7)", "Basic sum works, 7D");
is($v1 + $v2, $v2 + $v1, "Addition is commutative");
is(($v1 + $v2) + $v3, $v1 + ($v2 + $v3), "Addition is associative");
is($v1 + $origin3d, $v1, "Addition with origin leaves original");

# {
#     my Vector $a = $v1;
#     $a += $v2;
#     is(~($v1 + $v2), ~$a, "+= works");
# }
# is(~($v1 + $v2), "(4, 6, 3)", "Basic sum works");

is(~($v1 - $v2), "(-2, -2, 3)", "Basic subtraction works");
is($v1 - $v2, -($v2 - $v1), "Subtraction is anticommutative");
is($v1 - $origin3d, $v1, "Subtracting the origin leaves original");
is(-$origin3d, $origin3d, "Negating the origin leaves the origin");
is(~(-$v2), "(-3, -4, 0)", "Negating works");
# {
#     my Vector $a = $v1;
#     $a -= $v2;
#     is(~($v1 - $v2), ~$a, "+= works");
# }

#lengths
is($origin3d.Length, 0, "Origin has 0 length");
is($v6.Length, 1, "Simple length calculation");
is($v8.Length, 1, "Simple length calculation");

for @vectors -> $v
{
    # is_approx($v.Length ** 2, ⎡$v ⎤ * ⎡$v ⎤, "v.Length squared equals ⎡v ⎤ squared");
    is_approx($v.Length ** 2, $v dot $v, "v.Length squared equals v ⋅ v");
    # is_approx(abs($v) ** 2, $v ⋅ $v, "abs(v) squared equals v ⋅ v");
}

for @vectors -> $v
{
    my Vector $vn = $v * 4.5;
    is_approx($vn.Length, $v.Length * 4.5, "Scalar by Vector multiply gets proper length");
    is_approx_vector($vn.Unitize, $v.Unitize, "Scalar by Vector multiply gets proper direction");
    is_approx_vector($vn, 4.5 * $v, "Scalar by Vector multiply is commutative");
}

for @vectors -> $v
{
    my Vector $vn = $v / 4.5;
    is_approx($vn.Length, $v.Length / 4.5, "Vector by Scalar divide gets proper length");
    is_approx_vector($vn.Unitize, $v.Unitize, "Vector by Scalar divide gets proper direction");
    is_approx_vector($vn, $v * (1.0 / 4.5), "Vector by Scalar divide is equal to multiplication by reciprocal");
}

#dot product tests
is_approx($v7 dot $v8, 0, "Perpendicular vectors have 0 dot product");

for ($v1, $v2, $v3) X ($v1, $v2, $v3) -> $x, $y
{
    is_approx($x ⋅ $y, $y ⋅ $x, "x ⋅ y = y ⋅ x");
    is_approx($x ⋅ ($y + $v3), ($x ⋅ $y) + ($x ⋅ $v3), "x ⋅ (y + v3) = x ⋅ y + x ⋅ v3");
}

for ($v5, $v6) X ($v5, $v6) -> $x, $y
{
    is_approx($x ⋅ $y, $y ⋅ $x, "x ⋅ y = y ⋅ x");
    is_approx($x ⋅ ($y + $v6), ($x ⋅ $y) + ($x ⋅ $v6), "x ⋅ (y + v6) = x ⋅ y + x ⋅ v3");
}

dies_ok( { $v5 ⋅ $v7 }, "You can't do dot products of different dimensions");
dies_ok( { $v7 dot $v5 }, "You can't do dot products of different dimensions");

# {
#     my $a = $v1;
#     $a ⋅= $v2;
#     is_approx($v1 ⋅ $v2, $a, "⋅= works");
# }

# {
#     my Vector $a = $v1;
#     dies_ok( { $a ⋅= $v2; }, "You can't do dot= on a Vector variable");
# }

#cross product tests
is(~($v1 × $v2), "(-12, 9, -2)", "Basic cross product works");

for ($v1, $v2, $v3) X ($v1, $v2, $v3) -> $x, $y
{
    my $cross = $x × $y;
    is_approx($cross ⋅ $x, 0, "(x × y) ⋅ x = 0");
    is_approx($cross ⋅ $y, 0, "(x × y) ⋅ y = 0");
    is_approx_vector($cross, -($y × $x), "x × y = -y × x");
    is_approx($cross.Length ** 2, $x.Length ** 2 * $y.Length ** 2 - ($x ⋅ $y) ** 2, 
              "|x × y|^2 = |x|^2 * |y|^2 - (x ⋅ y)^2");
}

for ($v7, $v8, $v9, $v10) X ($v7, $v8, $v9, $v10) -> $x, $y
{
    my $cross = $x × $y;
    is_approx($cross ⋅ $x, 0, "(x × y) ⋅ x = 0");
    is_approx($cross ⋅ $y, 0, "(x × y) ⋅ y = 0");
    is_approx_vector($cross, -($y × $x), "x × y = -y × x");
    is_approx($cross.Length ** 2, $x.Length ** 2 * $y.Length ** 2 - ($x ⋅ $y) ** 2, 
              "|x × y|^2 = |x|^2 * |y|^2 - (x ⋅ y)^2");
}

lives_ok { $v7 cross $v8, "7D cross product works writing out cross"}
dies_ok( { $v1 × $v7 }, "You can't do cross products of different dimensions");
dies_ok( { $v5 × $v6 }, "You can't do 5D cross products");
dies_ok( { $v1 cross $v7 }, "You can't do cross products of different dimensions");
dies_ok( { $v5 cross $v6 }, "You can't do 5D cross products");

# {
#     my $a = $v1;
#     $a ×= $v2;
#     is_approx($v1 × $v2, $a, "×= works");
# }

# UnitVector tests
{
    my UnitVector $a = Vector.new(1, 0, 0);
#    isa_ok($a, UnitVector, "Variable is of type UnitVector"); 
    isa_ok($a, Vector, "Variable is of type Vector");
}

# {
#     my UnitVector $a = UnitVector.new(1, 0, 0);
#     my $b = $a;
#     $b += $v2;
#     is_approx($a + $v2, $b, "+= works on UnitVector");
# }
# {
#     my UnitVector $a = Vector.new(1, 0, 0);
#     dies_ok( { $a += $v2; }, "Catch if += violates the UnitVector constraint");
# }

# test prefix plus
# isa_ok(+$v1, Vector, "Prefix + works on the Vector class");
dies_ok( { $v1.Num; }, "Make sure .Num does not work on 3D vector");

# test extensions
class VectorWithLength is Vector
{
    has $.length;
    
    multi method new (*@x) 
    {
        self.bless(*, coordinates => @x, length => sqrt [+] (@x »*« @x));
    }
    
    multi method new (@x) 
    {
        self.bless(*, coordinates => @x, length => sqrt [+] (@x »*« @x));
    }
    
    submethod Length
    {
        $.length;
    }
}

my VectorWithLength $vl = VectorWithLength.new($v7.coordinates);
isa_ok($vl, VectorWithLength, "Variable is of type VectorWithLength");
my $vlc = eval($vl.perl);
isa_ok($vlc, VectorWithLength, "eval'd perl'd variable is of type VectorWithLength");

done_testing;