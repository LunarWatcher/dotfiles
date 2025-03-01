# Soundboard

This folder contains a backing script for a hackish soundboard that injects the audio into a virtual microphone stream. This script deals with the audio management bits, and not the display bits.

Apps use monitor of soundboard_sink. Apps that don't support pulseaudio/pipewire monitors can be forced to use it with pavu.

The display part of the soundboard is stored in `misc/AutokeyPublic/Meta/Soundboard selector.py` (+ `Kill soundboard.py`).

Source files go in `~/Documents/Soundboard`. The soundboard audio files have not been included, and must be set up manually.
