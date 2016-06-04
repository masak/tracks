tracks_seen = {}

class Vec4D(tuple):
    def __new__(cls, x_int, x_q, y_int, y_q):
        return tuple.__new__(cls, (x_int, x_q, y_int, y_q))
    def __add__(self, other):
        return Vec4D(self[0]+other[0], self[1]+other[1], self[2]+other[2], self[3]+other[3])


def is_circular(x_int, x_q, y_int, y_q, direction):
    return x_int == x_q == y_int == y_q == 0 and direction == 0


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

LEFT_DIRECTIONS = [
    (0, 1, 1, -1),
    (1, -1, 0, 1),
    (-1, 1, 0, 1),
    (0, -1, 1, -1),
    (0, -1, -1, 1),
    (-1, 1, 0, -1),
    (1, -1, 0, -1),
    (0, 1, -1, 1),
]

RIGHT_DIRECTIONS = LEFT_DIRECTIONS[-1:] + LEFT_DIRECTIONS[:-1]

STRAIGHT_DIRECTIONS = [
    (1, 0, 0, 0),
    (0, 1, 0, 1),
    (0, 0, 1, 0),
    (0, -1, 0, 1),
    (-1, 0, 0, 0),
    (0, -1, 0, -1),
    (0, 0, -1, 0),
    (0, 1, 0, -1),
]

def search(track, x_int, x_q, y_int, y_q, direction):
    if len(track) == 16:
        if is_circular(x_int, x_q, y_int, y_q, direction) and not seen_before(track):
            print(track)
    else:
        search(
            track + "L",
            x_int + LEFT_DIRECTIONS[direction][0],
            x_q + LEFT_DIRECTIONS[direction][1],
            y_int + LEFT_DIRECTIONS[direction][2],
            y_q + LEFT_DIRECTIONS[direction][3],
            (direction + 1) % 8,
        )
        search(
            track + "R",
            x_int + RIGHT_DIRECTIONS[direction][0],
            x_q + RIGHT_DIRECTIONS[direction][1],
            y_int + RIGHT_DIRECTIONS[direction][2],
            y_q + RIGHT_DIRECTIONS[direction][3],
            (direction - 1) % 8,
        )
        if track.count("S") < 2:
            search(
                track + "S",
                x_int + STRAIGHT_DIRECTIONS[direction][0],
                x_q + STRAIGHT_DIRECTIONS[direction][1],
                y_int + STRAIGHT_DIRECTIONS[direction][2],
                y_q + STRAIGHT_DIRECTIONS[direction][3],
                direction,
            )


search("BB", 2, 0, 0, 0, 0)
