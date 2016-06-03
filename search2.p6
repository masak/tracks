constant SIDE_OCTAGON = sqrt(2 - sqrt(2));

sub seen-before($track) {
    sub mirror($track) { $track.trans("LR" => "RL") }
    sub backwards { "BB" ~ mirror($track.substr(2)).flip }
    sub mirror-backwards { "BB" ~ $track.substr(2).flip }

    state %seen;
    my $rep = [min] $track, mirror($track), backwards(), mirror-backwards();
    return %seen{$rep}++;
}

sub is-circular($x, $y, $direction) {
    sqrt($x * $x + $y * $y) < 1e-3 && abs($direction) % (2 * pi) < 1e-3;
}

sub search($track = "BB", $x = 2, $y = 0, $direction = 0) {
    if $track.chars == 16 {
        if is-circular($x, $y, $direction) && !seen-before($track) {
            say $track;
        }
    }
    else {
        search(
            $track ~ "L",
            $x + SIDE_OCTAGON * cos($direction + pi/8),
            $y + SIDE_OCTAGON * sin($direction + pi/8),
            $direction + pi/4,
        );
        search(
            $track ~ "R",
            $x + SIDE_OCTAGON * cos($direction - pi/8),
            $y + SIDE_OCTAGON * sin($direction - pi/8),
            $direction - pi/4,
        );
        if $track.comb.grep("S") < 2 {
            search(
                $track ~ "S",
                $x + cos($direction),
                $y + sin($direction),
                $direction,
            );
        }
    }
}

search();
