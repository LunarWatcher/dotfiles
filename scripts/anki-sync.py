# Preface:
# Not sure who thought it was a good idea to only allow for a central server, but here we are.
# There is an unofficial server, but it's incompatible with my network model.
# Flatpak prevents the use of langfield/ki, which has an explicit python install system for whatever
# dumb reason.
#
# This leaves this monstrocity as the only option

import os
from sys import argv
from platform import system as p
import shutil as fs
import errno


if len(argv) < 2:
    raise RuntimeError("Expected either pull or push")

mOS = p()

home = os.path.expanduser("~")

LINUX_DEFAULT = os.path.join(home, ".local/share/Anki2")
FLATPAK_DEFAULT = os.path.join(home, ".var/app/net.ankiweb.Anki/data/Anki2/")
WINDOWS_DEFAULT = os.path.join(os.getenv("APPDATA", ""), "Anki2")

SYNC_LOCATION_ENV = "ANKISYNC_REMOTEDIR"
SYNC_SOURCE_ENV   = "ANKISYNC_LOCALDIR"
SYNC_USEFLATPAK   = "ANKISYNC_USE_FLATPAK"
SYNC_USENORMAL    = "ANKISYNC_USE_NORMAL"

WINDOWS_DUMP_DEFAULT = r"Z:\Documents\anki"
LINUX_DUMP_DEFAULT = "/media/NAS1/Documents/anki"

useFlatpak = os.getenv(SYNC_USEFLATPAK) != None
useNormal = os.getenv(SYNC_USENORMAL) != None
remotePath = os.getenv(SYNC_LOCATION_ENV) if os.getenv(SYNC_LOCATION_ENV) else WINDOWS_DUMP_DEFAULT if mOS == "Windows" else LINUX_DUMP_DEFAULT
localPath = os.getenv(SYNC_SOURCE_ENV)

if mOS == "Linux":
    if os.path.exists(LINUX_DEFAULT) or useNormal:
        localPath = LINUX_DEFAULT
    elif os.path.exists(FLATPAK_DEFAULT) or useFlatpak:
        localPath = FLATPAK_DEFAULT
    else:
        raise RuntimeError("Failed to determine source. If this is your first pull, please define " + SYNC_SOURCE_ENV)
else:
    # arsed validating
    localPath = WINDOWS_DEFAULT

source = None
dest = None

if argv[1] == "pull":
    source = remotePath
    dest = localPath
elif argv[1] == "push":
    source = localPath
    dest = remotePath
else:
    raise RuntimeError("Invalid command; expected pull or push, got some other garbage")

if not os.path.exists(source):
    raise RuntimeError("The source directory doesn't exist. if you're pulling, did you mount the NAS?")
# python is such trash. This is prone to vulnerabilities on some operating ssystems (but doesn't specify which)
try:
    fs.rmtree(dest)
except OSError as e:
    if e.errno == errno.ENOENT:
        # No folder exists means nothing to delete
        pass
    else: raise
try:
    fs.copytree(source, dest)
except OSError as e:
    if e.errno == errno.EEXIST or e.errno == errno.ENOENT:
        fs.copy(source, dest)
    else:
        raise
