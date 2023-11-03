@echo off
REM Never gonna give you up
REM never gonna let you down
REM Always gonna rickroll whenever I can
REM
REM Connect to the SSHFS server

REM required because paths
REM Fucking windows
set PATH=C:\Program Files\SSHFS-Win\bin\;%PATH%

REM connect. The port is stored in a system variable because seekrits
sshfs-win.exe svc \sshfs.kr\olivia@nova.remote!%NAS_PORT%\media\NAS Z:
