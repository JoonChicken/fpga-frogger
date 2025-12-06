palette = {
    '.': '00',
    'D': '05',
    'L': '0C',
    'O': '34',
    'W': '3F',
    'P': '01',
}

def read_sprite(path):
    lines = [line.rstrip('\n') for line in open(path)]
    lines = [ln for ln in lines if ln.strip() != '']
    assert len(lines) == 32
    for ln in lines:
        assert len(ln) == 32
    return lines

sprites = [
    read_sprite('frog_front.txt'),
    read_sprite('frog_back.txt'),
    read_sprite('frog_left.txt'),
    read_sprite('frog_right.txt'),
]

with open('frog.mem', 'w') as f:
    for s in sprites:
        for y in range(32):
            for x in range(32):
                ch = s[y][x]
                f.write(palette[ch] + '\n')
