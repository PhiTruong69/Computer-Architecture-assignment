import struct

# 2 số float bất kỳ
a = 0.0
b = 0.0


with open("FLOAT2.BIN", "wb") as f:
    f.write(struct.pack('ff', a, b))