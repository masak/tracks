class Vec4D {
    has int ($.x_int, $.x_q, $.y_int, $.y_q);
    method new($x_int, $x_q, $y_int, $y_q) { self.bless(:$x_int, :$x_q, :$y_int, :$y_q) }
    method is-zero { $.x_int == $.x_q == $.y_int == $.y_q == 0 }
}

multi infix:<+>(Vec4D $l, Vec4D $r) {
    Vec4D.new($l.x_int + $r.x_int, $l.x_q + $r.x_q, $l.y_int + $r.y_int, $l.y_q + $r.y_q);
}
        
sub is-circular(Vec4D $pos, $direction) { $pos.is-zero && $direction == 0 }

sub seen-before($track) {
    sub mirror($track) { $track.trans("LR" => "RL") }
    sub backwards { "BB" ~ mirror($track.substr(2)).flip }
    sub mirror-backwards { "BB" ~ $track.substr(2).flip }

    state %seen;
    my $representative
        = [min] $track, mirror($track), backwards(), mirror-backwards();
    return %seen{$representative}++;
}

constant LEFT_DIRECTIONS = [
    Vec4D.new(0, 1, 1, -1),
    Vec4D.new(1, -1, 0, 1),
    Vec4D.new(-1, 1, 0, 1),
    Vec4D.new(0, -1, 1, -1),
    Vec4D.new(0, -1, -1, 1),
    Vec4D.new(-1, 1, 0, -1),
    Vec4D.new(1, -1, 0, -1),
    Vec4D.new(0, 1, -1, 1),
];

constant RIGHT_DIRECTIONS = LEFT_DIRECTIONS.rotate(-1);

constant STRAIGHT_DIRECTIONS = [
    Vec4D.new(1, 0, 0, 0),
    Vec4D.new(0, 1, 0, 1),
    Vec4D.new(0, 0, 1, 0),
    Vec4D.new(0, -1, 0, 1),
    Vec4D.new(-1, 0, 0, 0),
    Vec4D.new(0, -1, 0, -1),
    Vec4D.new(0, 0, -1, 0),
    Vec4D.new(0, 1, 0, -1),
];

sub search(Str $track, Vec4D $pos, $direction) {
    if $track.chars == 16 {
        if is-circular($pos, $direction) && !seen-before($track) {
            say $track;
        }
    }
    else {
        search($track ~ "L", $pos + LEFT_DIRECTIONS[$direction], ($direction + 1) % 8);
        search($track ~ "R", $pos + RIGHT_DIRECTIONS[$direction], ($direction - 1) % 8);
        if $track.comb("S") < 2 {
            search($track ~ "S", $pos + STRAIGHT_DIRECTIONS[$direction], $direction);
        }
    }
}

search("BB", Vec4D.new(2, 0, 0, 0), 0)
