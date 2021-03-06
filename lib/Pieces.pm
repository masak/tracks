sub rot($x, $y, $angle = -44.55) {
    my \sina = sin($angle / 180 * π);
    my \cosa = cos($angle / 180 * π);
    my ($rx, $ry) = $x * cosa - $y * sina, $x * sina + $y * cosa;
    return "$rx, $ry";
}

sub infix:<y->($coords, $dy) {
    $coords ~~ /(.*)\,(.*)/
        or die "not coords";
    "$0,{$1 - $dy}";
}

sub out-bulb($x, $y, $angle, $mdy = 0) {
    qq:to 'PATH-FRAGMENT';
        L {rot($x + 4, $y, $angle) y- $mdy}
          {rot($x + 4, $y - 2, $angle) y- $mdy}
        C {rot($x + 3, $y - 2.5, $angle) y- $mdy} {rot($x + 3, $y - 5, $angle) y- $mdy} {rot($x + 5, $y - 5, $angle) y- $mdy}
          {rot($x + 7, $y - 5, $angle) y- $mdy} {rot($x + 7, $y - 2.5, $angle) y- $mdy} {rot($x + 6, $y - 2, $angle) y- $mdy}
        L {rot($x + 6, $y, $angle) y- $mdy}
          {rot($x + 10, $y, $angle) y- $mdy}
    PATH-FRAGMENT
}

sub in-bulb($x, $y, $angle, $mdy = 0) {
    qq:to 'PATH-FRAGMENT';
        L {rot($x + 10, $y, $angle) y- $mdy}
          {rot($x + 6.5, $y, $angle) y- $mdy}
          {rot($x + 6.5, $y - 1, $angle) y- $mdy}
        C {rot($x + 7.5, $y - 1.8, $angle) y- $mdy} {rot($x + 7, $y - 4.4, $angle) y- $mdy} {rot($x + 5, $y - 4.4, $angle) y- $mdy}
          {rot($x + 3, $y - 4.4, $angle) y- $mdy} {rot($x + 2.5, $y - 1.8, $angle) y- $mdy} {rot($x + 3.5, $y - 1, $angle) y- $mdy}
        L {rot($x + 3.5, $y, $angle) y- $mdy}
          {rot($x, $y, $angle) y- $mdy}
    PATH-FRAGMENT
}

sub straight-middle-piece {
    qq:to 'PATH';
        M 5,1
        {out-bulb 5,1,0}
        L 15,100
        {in-bulb 5,100,0}
        Z
    PATH
}

sub straight($x, $y, $angle = 0) is export {
    qq:to 'PIECE';
      <g transform="translate({$x}, {$y}) rotate({$angle}) translate(-10,-97.3)">
        <rect width="3" height="99" x="0" y="1" />
        <path d="{straight-middle-piece}" />
        <rect width="3" height="99" x="17" y="1" />
      </g>
    PIECE
}

sub curved-left-piece {
    qq:to 'PATH';
        M {rot 93,0}
        A 93,93 0 0 1 93,0
        L 90,0
        A 90,90 0 0 0 {rot 90,0}
        Z
    PATH
}

sub curved-middle-piece {
    qq:to 'PATH';
        M {rot 105,0}
        A 105,105 0 0 1 105,0
        {in-bulb 95,0,0}
        A 95,95 0 0 0 {rot 95,0}
        {out-bulb 95,0,-44.55}
        Z
    PATH
}

sub curved-right-piece {
    qq:to 'PATH';
        M {rot 110,0}
        A 110,110 0 0 1 110,0
        L 107,0
        A 107,107 0 0 0 {rot 107,0}
        Z
    PATH
}

sub curved-left($x, $y, $angle = 0) is export {
    qq:to 'PIECE';
      <g transform="translate({$x}, {$y}) rotate({$angle}) translate(-100,2.7)">
        <path d="{curved-left-piece}" />
        <path d="{curved-middle-piece}" />
        <path d="{curved-right-piece}" />
      </g>
    PIECE
}

sub curved-right($x, $y, $angle = 0) is export {
    qq:to 'PIECE';
      <g transform="translate({$x}, {$y}) rotate({$angle}) scale(-1,1) translate(-100,2.7)">
        <path d="{curved-left-piece}" />
        <path d="{curved-middle-piece}" />
        <path d="{curved-right-piece}" />
      </g>
    PIECE
}

constant BRIDGE_LIFT = 20;
constant CTR_POINT1 = [-20, 5];
constant CTR_POINT2 = [30, -10];
constant CTR_POINT3 = [0, -10];
constant CTR_POINT4 = [-20, 7];
constant T1 = 0.85;
constant T2 = 0.8;
constant T3 = 0.7;
constant T4 = 0.55;

sub infix:<xy+>($coords, [$dx, $dy]) {
    $coords ~~ /(.*)\,(.*)/
        or die "not coords";
    "{$0 + $dx},{$1 + $dy}";
}

sub infix:<xy->($coords, [$dx, $dy]) {
    $coords ~~ /(.*)\,(.*)/
        or die "not coords";
    "{$0 - $dx},{$1 - $dy}";
}

sub bridge1($x, $y, $angle = 67.5) is export {
    qq:to 'PIECE';
      <g transform="translate({$x}, {$y})">
        <path d="M {rot(-10, -96.3, $angle) y- BRIDGE_LIFT}
                 C {rot(-10, -96.3, $angle) y- BRIDGE_LIFT xy+ CTR_POINT1}
                     {rot(-10, 2.7, $angle) xy+ CTR_POINT2}
                     {rot -10, 2.7, $angle}
                 L {rot -7, 2.7, $angle}
                 C {rot(-7, 2.7, $angle) xy+ CTR_POINT2}
                     {rot(-7, -96.3, $angle) y- BRIDGE_LIFT xy+ CTR_POINT1}
                     {rot(-7, -96.3, $angle) y- BRIDGE_LIFT}
                 Z" />
        <path d="M {rot(-5, -96.3, $angle) y- BRIDGE_LIFT}
                 {out-bulb -5, -96.3, $angle, BRIDGE_LIFT}
                 C {rot(-5 + 10, -96.3, $angle) y- BRIDGE_LIFT xy+ CTR_POINT1}
                     {rot(5, 2.7, $angle) xy+ CTR_POINT2}
                     {rot 5, 2.7, $angle}
                 {in-bulb -5, 2.7, $angle}
                 C {rot(-5, 2.7, $angle) xy+ CTR_POINT2}
                     {rot(-5, -96.3, $angle) y- BRIDGE_LIFT xy+ CTR_POINT1}
                     {rot(-5, -96.3, $angle) y- BRIDGE_LIFT}
                 Z" />
        <path d="M {rot(7, -96.3, $angle) y- BRIDGE_LIFT}
                 C {rot(7, -96.3, $angle) y- BRIDGE_LIFT xy+ CTR_POINT1}
                     {rot(7, 2.7, $angle) xy+ CTR_POINT2}
                     {rot 7, 2.7, $angle}
                 L {rot 10, 2.7, $angle}
                   {rot 10, 2.7 * (1 - T4) + -96.3 * T4, $angle}
                 C {rot(10, 2.7 * (1 - T4) + -96.3 * T4, $angle) xy+ CTR_POINT3}
                     {rot(10, 2.7 * (1 - T3) + -96.3 * T3, $angle) xy+ CTR_POINT3}
                     {rot 10, 2.7 * (1 - T3) + -96.3 * T3, $angle}
                 L {rot 10, 2.7 * (1 - T1) + -96.3 * T1, $angle}
                 C {rot(10, 2.7 * (1 - T1) + -96.3 * T1, $angle) xy+ CTR_POINT3}
                     {rot(10, -96.3, $angle) y- BRIDGE_LIFT * T2 xy+ CTR_POINT4}
                     {rot(10, -96.3, $angle) y- BRIDGE_LIFT * T2}
                 L {rot(10, -96.3, $angle) y- BRIDGE_LIFT}
                 Z" />
      </g>
    PIECE
}

sub bridge2($x, $y, $angle = 67.5) is export {
    qq:to 'PIECE';
      <g transform="translate({$x}, {$y})">
        <path d="M {rot -10, -96.3, $angle}
                 C {rot(-10, -96.3, $angle) xy- CTR_POINT2}
                     {rot(-10, 2.7, $angle) y- BRIDGE_LIFT xy- CTR_POINT1}
                     {rot(-10, 2.7, $angle) y- BRIDGE_LIFT}
                 L {rot(-7, 2.7, $angle) y- BRIDGE_LIFT}
                 C {rot(-7, 2.7, $angle) y- BRIDGE_LIFT xy- CTR_POINT1}
                     {rot(-7, -96.3, $angle) xy- CTR_POINT2}
                     {rot -7, -96.3, $angle}
                 Z" />
        <path d="M {rot -5, -96.3, $angle}
                 {out-bulb -5, -96.3, $angle}
                 C {rot(-5 + 10, -96.3, $angle) xy- CTR_POINT2}
                     {rot(5, 2.7, $angle) y- BRIDGE_LIFT xy- CTR_POINT1}
                     {rot(5, 2.7, $angle) y- BRIDGE_LIFT}
                 {in-bulb -5, 2.7, $angle, BRIDGE_LIFT}
                 C {rot(-5, 2.7, $angle) y- BRIDGE_LIFT xy- CTR_POINT1}
                     {rot(-5, -96.3, $angle) xy- CTR_POINT2}
                     {rot -5, -96.3, $angle}
                 Z" />
        <path d="M {rot 7, -96.3, $angle}
                 C {rot(7, -96.3, $angle) xy- CTR_POINT2}
                     {rot(7, 2.7, $angle) y- BRIDGE_LIFT xy- CTR_POINT1}
                     {rot(7, 2.7, $angle) y- BRIDGE_LIFT}
                 L {rot(10, 2.7, $angle) y- BRIDGE_LIFT}
                   {rot(10, 2.7, $angle) y- BRIDGE_LIFT * T2}
                 C {rot(10, 2.7, $angle) y- BRIDGE_LIFT * T2 xy- CTR_POINT4}
                     {rot(10, 2.7 * T1 + -96.3 * (1 - T1), $angle) xy+ CTR_POINT3}
                     {rot 10, 2.7 * T1 + -96.3 * (1 - T1), $angle}
                 L {rot 10, 2.7 * T3 + -96.3 * (1 - T3), $angle}
                 C {rot(10, 2.7 * T3 + -96.3 * (1 - T3), $angle) xy+ CTR_POINT3}
                     {rot(10, 2.7 * T4 + -96.3 * (1 - T4), $angle) xy+ CTR_POINT3}
                     {rot 10, 2.7 * T4 + -96.3 * (1 - T4), $angle}
                 L {rot 10, -96.3, $angle}
                 Z" />
      </g>
    PIECE
}

sub straight-clipped($x, $y, $angle = 0) is export {
    qq:to 'PIECE';
      <g transform="translate({$x}, {$y}) rotate({$angle}) translate(-10,-97.3)">
        <rect width="3" height="99" x="0" y="1" />
        <path d="{straight-middle-piece}" />
        <rect width="3" height="99" x="17" y="1" />
        <path d="M -2.5,72
                 C 0,70 20,69 22.5,71
                 L 20.1,97
                 C 20,97 4,95 -0.1,99
                 Z" style="fill: white" />
      </g>
    PIECE
}
