constant SIDE_OCTAGON = sqrt(2 - sqrt(2));

sub is-cycle($track) {
    my ($x, $y, $angle) = 0, 0, 0;
    for $track.comb {
        when "L" {
            $angle += pi/8;
            $x += SIDE_OCTAGON * cos($angle);
            $y += SIDE_OCTAGON * sin($angle);
            $angle += pi/8;
        }
        when "R" {
            $angle -= pi/8;
            $x += SIDE_OCTAGON * cos($angle);
            $y += SIDE_OCTAGON * sin($angle);
            $angle -= pi/8;
        }
        default {   # the "B" and "S" cases
            $x += cos($angle);
            $y += sin($angle);
        }
    }
    return abs($x) < 1e-3 && abs($y) < 1e-3 && abs($angle) % (2 * pi) < 1e-3;
}

sub seen($track) {
    sub mirror($track) { $track.trans("LR" => "RL") }
    sub backwards { "BB" ~ mirror($track.substr(2)).flip }
    sub mirror-backwards { "BB" ~ $track.substr(2).flip }

    state %seen;
    my $representative
        = [min] $track, mirror($track), backwards(), mirror-backwards();
    return %seen{$representative}++;
}

sub search($track) {
    if $track.chars == 16 {
        if is-cycle($track) && !seen($track) {
            say $track;
        }
    }
    else {
        search($track ~ "L");
        search($track ~ "R");
        if $track.comb("S") < 2 {
            search($track ~ "S");
        }
    }
}

search("BB");
