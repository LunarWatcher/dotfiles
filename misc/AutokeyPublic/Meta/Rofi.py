import os
import subprocess
from os import walk
from os.path import join

import time

# very simple logger
def log(line):
    system.exec_command('echo "{}" >> /tmp/autokey.log'.format(line))

# TODO: Fix
USER = os.getenv('USER')
AUTOKEY_DATA_DIR = '/home/{}/programming/dotfiles/misc/AutokeyPublic'.format(USER)


DATA_FILES = []
for (dirpath, dirnames, filenames) in walk(AUTOKEY_DATA_DIR):
    # TODO: expand to script support
    # TODO: Multiple menus how?
    # Two columns does not work here
    files = [join(dirpath, f) for f in filenames if f.endswith(('.txt'))]
    DATA_FILES.extend(files)



query = subprocess.run(
    ['rofi', '-dmenu', '-p', 'Select Phrase'], 
    input='\n'.join([os.path.basename(f).split('.')[0] for f in DATA_FILES]), 
    text=True, 
    capture_output=True
).stdout.strip()

for f in DATA_FILES:
    if os.path.basename(f).split('.')[0] == query:
        with open(f) as f:
            phrase = f.read()
            
        prev = None
        try:
            prev = clipboard.get_clipboard()
        except:
            pass
        clipboard.fill_clipboard(phrase)
        time.sleep(0.1)
        keyboard.send_keys("<ctrl>+v")
        time.sleep(0.1)
        
        if prev is not None:
            clipboard.fill_clipboard(prev)

        exit(0)
raise RuntimeError("Script borked")
