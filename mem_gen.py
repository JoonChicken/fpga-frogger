palette = {
    '.': '00',  # background / transparent
    'H': '24',  # bright highlight ring
    'B': '10',  # medium bark / ring
}

def read_sprite(path):
    lines = [line.rstrip('\n') for line in open(path)]
    lines = [ln for ln in lines if ln.strip() != '']
    assert len(lines) == 32
    for ln in lines:
        assert len(ln) == 32
    return lines

sprites = [
    read_sprite('log_left.txt'),
    read_sprite('log_middle.txt'),
    read_sprite('log_right.txt'),
]

with open('log.mem', 'w') as f:
    for s in sprites:
        for y in range(32):
            for x in range(32):
                ch = s[y][x]
                f.write(palette[ch] + '\n')
