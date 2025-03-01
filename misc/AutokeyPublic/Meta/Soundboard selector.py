import os
import subprocess
from os.path import join, isfile
import json
import time

from math import floor, ceil

USER = os.getenv('USER')
SOUNDBOARD_DIR = '/home/{}/Music/Soundboard'.format(USER)
SOUNDBOARD_METADIR = '/home/{}/programming/dotfiles/soundboard'.format(USER)


soundboardFiles = []

for file in os.listdir(SOUNDBOARD_DIR):
    if not isfile(join(SOUNDBOARD_DIR, file)):
        continue
 
    soundboardFiles.append(file) 



stdin = []

for filename in soundboardFiles:
    #args=("ffprobe", 
    #   "-v", "error",
    #    "-show_entries", "format=duration",
    #    "-of", "default=noprint_wrappers=1:nokey=1",
    #    join(SOUNDBOARD_DIR, filename)
    #)
    #popen = subprocess.Popen(args, stdout = subprocess.PIPE)

    #output = popen.stdout.read().decode("UTF-8")
    #duration = float(output)
    
    row = filename
    #row += "\n<span foreground=\"#9ca0b0\">"
    #row += str(floor(duration / 60.0))
    #row += ":"
    #row += str(ceil(duration % 60)).zfill(2)
    #row += "</span>"
   
    stdin.append(
        row
    )

query = subprocess.run(
    [
        'rofi',
        '-dmenu',
        '-p', 'Select soundboard noise',
        '-i',
        "-format", "i",
        "-sep", "$",
        "-eh", "1",
        "-markup-rows"
    ], 
    input='$'.join(stdin),
    text=True, 
    capture_output=True
).stdout.strip()

# If aborted, query == ""
# (yes, I could check the return codes, but this is more convenient right now, and means I don't need to search kagi for subprocess docs)
if query != "":

    idx = int(query)
    filename = soundboardFiles[idx]
    
    process = subprocess.Popen([
        join(SOUNDBOARD_METADIR, "soundboard.sh"),
        "play",
        filename
    ], stdout = subprocess.PIPE)
    process.wait()
