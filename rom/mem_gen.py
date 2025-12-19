# change as needed
palette = {
    '.': "00",
    'R': "30",
    'D': "20",
    'G': "2F",
    'Y': "3C",
}

def read_sprite(path):
    lines = [line.rstrip('\n') for line in open(path)]
    lines = [ln for ln in lines if ln.strip() != '']
    assert len(lines) == 32
    for ln in lines:
        assert len(ln) == 32
    return lines

sprites = [
    read_sprite('car.txt'),
]

with open('car.mem', 'w') as f:
    for s in sprites:
        for y in range(32):
            for x in range(32):
                ch = s[y][x]
                f.write(palette[ch] + '\n')
