from math import cos, hypot, pi, sin, sqrt

SIDE_OCTAGON = sqrt(2 - sqrt(2))
tracks_seen = {}

def is_circular(x, y, direction):
    return hypot(x, y) < 1e-3 and abs(direction) % (2 * pi) < 1e-3


def seen_before(track):
    def mirror(s):
        def swap_L_and_R(c):
            return "L" if c == "R" else "R" if c == "L" else c
        return "".join(map(swap_L_and_R, list(s)))

    def backwards():
        return "BB" + mirror(track[2:])[::-1]

    def mirror_backwards():
        return "BB" + track[2:][::-1]

    rep = min(track, mirror(track), backwards(), mirror_backwards())
    if rep in tracks_seen:
        return True
    else:
        tracks_seen[rep] = True
        return False


def search(track, x, y, direction):
    if len(track) == 16:
        if is_circular(x, y, direction) and not seen_before(track):
            print(track)
    else:
        search(
            track + "L",
            x + SIDE_OCTAGON * cos(direction + pi/8),
            y + SIDE_OCTAGON * sin(direction + pi/8),
            direction + pi/4,
        )
        search(
            track + "R",
            x + SIDE_OCTAGON * cos(direction - pi/8),
            y + SIDE_OCTAGON * sin(direction - pi/8),
            direction - pi/4,
        )
        if track.count("S") < 2:
            search(
                track + "S",
                x + cos(direction),
                y + sin(direction),
                direction,
            )


search("BB", 2, 0, 0)
