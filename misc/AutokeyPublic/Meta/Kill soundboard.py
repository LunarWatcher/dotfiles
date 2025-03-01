import os

if os.system("killall -9 paplay") != 0:
    raise RuntimeError("Failed to kill paplay")