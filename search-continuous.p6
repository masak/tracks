constant SIDE_OCTAGON = sqrt(2 - sqrt(2));

sub seen(Str $track) {
    sub mirror($track) { $track.trans("LR" => "RL") }
    sub backwards { "BB" ~ mirror($track.substr(2)).flip }
    sub mirror-backwards { "BB" ~ $track.substr(2).flip }

    state %seen;
    my $representative
        = [min] $track, mirror($track), backwards(), mirror-backwards();
    return %seen{$representative}++;
}

class Track {
    has Str $.name;
    has Real $.x;
    has Real $.y;
    has Real $.angle;

    method append-L {
        return Track.new(
            :name($.name ~ "L"),
            :x($!x + SIDE_OCTAGON * cos($!angle + pi/8)),
            :y($!y + SIDE_OCTAGON * sin($!angle + pi/8)),
            :angle($!angle + pi/4),
        );
    }

    method append-R {
        return Track.new(
            :name($.name ~ "R"),
            :x($!x + SIDE_OCTAGON * cos($!angle - pi/8)),
            :y($!y + SIDE_OCTAGON * sin($!angle - pi/8)),
            :angle($!angle - pi/4),
        );
    }

    method append-S {
        return Track.new(
            :name($.name ~ "S"),
            :x($!x + cos($!angle)),
            :y($!y + sin($!angle)),
            :$!angle,
        );
    }

    method !within($distance) {
        sqrt($!x * $!x + $!y * $!y) < $distance;
    }

    method is-cycle {
        return self!within(1e-3) && abs($!angle) % (2 * pi) < 1e-3;
    }

    method is-almost-cycle {
        return self!within(0.99) && abs($!angle) % (2 * pi) < 1e-3;
    }
}

my @queue = Track.new(:name<BB>, :x(2), :y(0), :angle(0));

my $length = 1;
loop {
    my $track = @queue.shift;
    if $length < $track.name.chars {
        $length = $track.name.chars;
        say "-- Reached length $length. Queue is {@queue.elems}";
    }

    if $track.is-cycle && !seen($track.name) {
        say $track.name;
    }
    elsif $track.is-almost-cycle && !seen($track.name) {
        say "{$track.name} ({$track.x}, {$track.y})";
    }

    @queue.push(
        $track.append-L,
        $track.append-R,
        $track.append-S,    # XXX: only if we don't already have 2 S
    );
}
