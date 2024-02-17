#!/usr/bin/bash

function panic {
    ntfy publish -p 5 alerts "Cron backups for device $(hostname) failed. You should be panicking. Are you panicking yet?"
}

autorestic backup -a || panic
