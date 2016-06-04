constant SIDE_OCTAGON = sqrt(2 - sqrt(2));

sub wiggle($track) {
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
    return sqrt($x * $x + $y * $y);
}

sub is-almost-cycle($track) {
    my $angle = $track.comb("L") - $track.comb("R");
    return wiggle($track) < 1 && $angle %% 8;
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

my @solutions;

sub search($track) {
    if $track.chars == 16 {
        if $track.comb("S") == 2 && is-almost-cycle($track) && !seen($track) {
            my $wiggle = wiggle($track);
            push @solutions, { :$track, :$wiggle };
        }
    }
    else {
        for <L R S> -> $piece {
            next if $piece eq "S" && $track.comb("S") >= 2;
            search($track ~ $piece);
        }
    }
}

search("BB");

for @solutions.sort(*.<wiggle>) {
    say "{.<track>} {.<wiggle>}";
}
