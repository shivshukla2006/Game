import wave, struct, math, random

sample_rate = 44100
duration = 0.5 # seconds, short loop
obj = wave.open('assets/audio/exhaust.wav','w')
obj.setnchannels(1) # mono
obj.setsampwidth(2)
obj.setframerate(sample_rate)

for i in range(int(sample_rate * duration)):
    t = float(i) / sample_rate
    freq = 100.0
    value = int(math.sin(2 * math.pi * freq * t) * 10000 + random.randint(-4000, 4000))
    data = struct.pack('<h', max(-32768, min(32767, value)))
    obj.writeframesraw(data)
obj.close()
