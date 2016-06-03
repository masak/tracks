from math import cos, hypot, pi, sin, sqrt

SIDE_OCTAGON = sqrt(2 - sqrt(2))
tracks_seen = {}

def is_circular(track):
    x, y, direction = 0, 0, 0

    def advance(distance, direction):
        nonlocal x, y
        x += distance * cos(direction)
        y += distance * sin(direction)

    def turn(angle):
        nonlocal direction
        direction += angle

    for char in track:
        if char == "L":
            advance(SIDE_OCTAGON, direction + pi/8)
            turn(pi/4)
        elif char == "R":
            advance(SIDE_OCTAGON, direction - pi/8)
            turn(-pi/4)
        else:
            advance(1, direction)

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


def search(track):
    if len(track) == 16:
        if is_circular(track) and not seen_before(track):
            print(track)
    else:
        search(track + "L")
        search(track + "R")
        if track.count("S") < 2:
            search(track + "S")


search("BB")
