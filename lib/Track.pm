use Pieces;

class Track {
    has $!mx;
    has $!my;
    has $!angle;

    has $!min-x;
    has $!min-y;
    has $!max-x;
    has $!max-y;

    has Str $!body;

    has $!x;
    has $!y;
    has $!scale;
    has Str $!fill;

    submethod BUILD(:$track, :$!x = 0, :$!y = 0, :$!scale = 1, :$!angle = 67.5, :$!fill = "") {
        $!mx = 0;
        $!my = 0;

        $!min-x = Inf;
        $!min-y = Inf;
        $!max-x = -Inf;
        $!max-y = -Inf;

        $!body = "";

        for $track.comb {
            when "S" { self!add-piece(&straight) }
            when "L" { self!add-piece(&curved-left) }
            when "R" { self!add-piece(&curved-right) }
            when "l" { self!add-colored-piece(&curved-left, "#f60") }
            when "r" { self!add-colored-piece(&curved-right, "#f60") }
            when "1" { self!add-piece(&bridge1) }
            when "2" { self!add-piece(&bridge2) }
            when "①" { self!add-colored-piece(&bridge1, "#c0f") }
            when "②" { self!add-colored-piece(&bridge2, "#c0f") }
            when "Ⓛ" { self!add-colored-piece(&curved-left, "#c0f") }
            when "Ⓡ" { self!add-colored-piece(&curved-right, "#c0f") }
            when "Ⓢ" { self!add-colored-piece(&straight, "#c0f") }
        }
    }

    constant $distance = 100 * sqrt(2 - sqrt(2));

    method !add-piece(&piece) {
        sub advance($d) {
            $!mx += $d * cos(($!angle - 90) / 180 * π);
            $!my += $d * sin(($!angle - 90) / 180 * π);
        }

        sub rr($x, $y, $angle) {
            my \sina = sin($angle / 180 * π);
            my \cosa = cos($angle / 180 * π);
            return $x * cosa - $y * sina, $x * sina + $y * cosa;
        }

        $!body ~= piece($!mx, $!my, $!angle);
        if &piece === &curved-left {
            my ($x1, $y1) = rr(|(rr(90, 0, -44.55) »+« (-100, 2.7)), $!angle) »+« ($!mx, $!my);
            my ($x2, $y2) = rr(|(rr(110, 0, -44.55) »+« (-100, 2.7)), $!angle) »+« ($!mx, $!my);
            my ($x3, $y3) = rr(|((90, 0) »+« (-100, 2.7)), $!angle) »+« ($!mx, $!my);
            my ($x4, $y4) = rr(|((110, 0) »+« (-100, 2.7)), $!angle) »+« ($!mx, $!my);
            my ($x5, $y5) = rr(|(rr(110, 0, -22.275) »+« (-100, 2.7)), $!angle) »+« ($!mx, $!my);

            $!min-x = min($x1, $x2, $x3, $x4, $x5, $!min-x);
            $!max-x = max($x1, $x2, $x3, $x4, $x5, $!max-x);
            $!min-y = min($y1, $y2, $y3, $y4, $y5, $!min-y);
            $!max-y = max($y1, $y2, $y3, $y4, $y5, $!max-y);

            $!mx -= 2.7 * cos(($!angle - 90) / 180 * π);
            $!my -= 2.7 * sin(($!angle - 90) / 180 * π);
            $!angle -= 22.5;
            advance($distance);
            $!angle -= 22.5;
            $!mx += 2.7 * cos(($!angle - 90) / 180 * π);
            $!my += 2.7 * sin(($!angle - 90) / 180 * π);
        }
        elsif &piece === &curved-right {
            my ($x1, $y1) = rr(|((rr(90, 0, -44.55) »+« (-100, 2.7)) »*« (-1, 1)), $!angle) »+« ($!mx, $!my);
            my ($x2, $y2) = rr(|((rr(110, 0, -44.55) »+« (-100, 2.7)) »*« (-1, 1)), $!angle) »+« ($!mx, $!my);
            my ($x3, $y3) = rr(|(((90, 0) »+« (-100, 2.7)) »*« (-1, 1)), $!angle) »+« ($!mx, $!my);
            my ($x4, $y4) = rr(|(((110, 0) »+« (-100, 2.7)) »*« (-1, 1)), $!angle) »+« ($!mx, $!my);
            my ($x5, $y5) = rr(|((rr(110, 0, -22.275) »+« (-100, 2.7)) »*« (-1, 1)), $!angle) »+« ($!mx, $!my);

            $!min-x = min($x1, $x2, $x3, $x4, $x5, $!min-x);
            $!max-x = max($x1, $x2, $x3, $x4, $x5, $!max-x);
            $!min-y = min($y1, $y2, $y3, $y4, $y5, $!min-y);
            $!max-y = max($y1, $y2, $y3, $y4, $y5, $!max-y);

            $!mx -= 2.7 * cos(($!angle - 90) / 180 * π);
            $!my -= 2.7 * sin(($!angle - 90) / 180 * π);
            $!angle += 22.5;
            advance($distance);
            $!angle += 22.5;
            $!mx += 2.7 * cos(($!angle - 90) / 180 * π);
            $!my += 2.7 * sin(($!angle - 90) / 180 * π);
        }
        else {
            advance(100);
        }
    }

    method !add-colored-piece(&piece, $color) {
        $!body ~= qq[<g style="fill: {$color}">];
        self!add-piece(&piece);
        $!body ~= q[</g>];
    }

    method svg {
        qq[<g transform="
            translate({$!x}, {$!y})
            scale({$!scale})
            translate({-($!min-x + $!max-x)/2}, {-($!min-y + $!max-y)/2})"
            {$!fill ?? qq[style="fill: {$!fill}"] !! ""}>{$!body}</g>];
    }
}
