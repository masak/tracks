use Pieces;

my $body = "";

sub add-piece(&piece, $x, $y, $angle) {
    $body ~= piece($x, $y, $angle);
}

sub text($text, $x, $y) {
    $body ~= qq[<text x="{$x}" y="{$y}" style="font-size:48px;font-family:Calibri" text-anchor="end">{$text}</text>];
}

my $angle = 90 - 22.5;

text("2 ×", 70, 70);
add-piece(&straight, 90, 70, $angle);
text("1 ×", 270, 70);
add-piece(&bridge1, 290, 70, $angle);
text("1 ×", 470, 70);
add-piece(&bridge2, 490, 70, $angle);
text("12 ×", 700, 70);
add-piece(&curved-left, 720, 70, $angle);

$body = qq[<g transform="scale(0.75)">{$body}</g>];

print qq:to 'SVG';
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>

    <svg
       xmlns="http://www.w3.org/2000/svg"
       version="1.1"
       width="600"
       height="60">

      {$body}
    </svg>
    SVG
