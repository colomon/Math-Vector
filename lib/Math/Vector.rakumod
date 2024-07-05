use v6.d;

class Math::Vector does Positional
{
    has @.components handles <AT-POS>;
    
    multi method new (*@x)
    {
        self.bless(components => @x);
    }
    
    multi method new (@x)
    {
        self.bless(components => @x);
    }
    
    method Str()
    {
        "^(" ~ @.components.join(', ') ~ ")";
    }
    
    method raku()
    {
        "Math::Vector.new(" ~ @.components.map({.perl}).join(', ') ~ ")";
    }
    
    method Num()
    {
        die "Cannot call Num on Vector!";
    }

    method dim()
    {
        @.components.elems;
    }

    method add($other)
    {
        Math::Vector.new(self.components »+« $other.components);
    }

    method subtract($other)
    {
        Math::Vector.new(self.components »-« $other.components);
    }

    method negate()
    {
        Math::Vector.new(0 <<-<< self.components);
    }

    method scale($other)
    {
        Math::Vector.new(self.components >>*>> $other);
    }

    method dot($other)
    {
        [+](self.components »*« $other.components);
    }

    method length() {
        sqrt(self.dot: self.conj);
    }

    method abs()
    {
        self.length;
    }

    method cross($other)
    {
        my ($a, $b) := self, $other;

        Math::Vector.new(
            $a[1] * $b[2] - $a[2] * $b[1],
            $a[2] * $b[0] - $a[0] * $b[2],
            $a[0] * $b[1] - $a[1] * $b[0],
        );
    }

    method unitize()
    {
        my $length = self.length;
        if $length > 1e-10
        {
            return Math::Vector.new(@.components >>/>> $length);
        }
        else
        {
            return Math::Vector.new(@.components);
        }
    }

    method conj()
    {
        Math::Vector.new(@.components>>.conj);
    }

    method round($r)
    {
        Math::Vector.new(@.components>>.round($r));
    }

    method cmp($other)
    {
        my $tol := $*TOLERANCE;

        given self.length - $other.length
        {
            when         * > $tol { More }
            when -$tol < * < $tol { Same }
            when -$tol > *        { Less }
        }

    }
}


subset Math::UnitVector of Math::Vector where { (1 - 1e-10) < $^v.length < (1 + 1e-10) };


multi infix:<+> (Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
{
    $a.add: $b;
}

multi infix:<->(Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
{
    $a.subtract: $b;
}

multi prefix:<->(Math::Vector $a) is export
{
    $a.negate;
}

multi infix:<*>(Math::Vector $a, $b) is export
{
    $a.scale: $b;
}

multi infix:<*>($a, Math::Vector $b) is export
{
    $b.scale: $a;
}

multi infix:</>(Math::Vector $a, $b) is export
{
    $a.scale: 1 / $b;
}

multi infix:<⋅>(Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
{
    $a.dot: $b;
}

multi infix:<dot>(Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
{
    $a.dot: $b;
}

multi infix:<×>(Math::Vector $a where { $a.dim == 3 }, Math::Vector $b where { $b.dim == 3 }) is export
{
    $a.cross: $b;
}

multi infix:<cross>(Math::Vector $a where { $a.dim == 3 }, Math::Vector $b where { $b.dim == 3 }) is export
{
    $a.cross: $b;
}

multi circumfix:<⎡ ⎤>(Math::Vector $a) is export
{
    $a.length;
}

multi infix:<cmp>(Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
{
    $a.cmp: $b;
}

