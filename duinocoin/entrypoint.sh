#!/bin/bash
# Only for PC, need a bit more work for AVR, and the option to pick between.
if [ -z ${username} ]; then username=DockerDuco; fi
if [ -z ${threads} ]; then threads=4; fi
if [ -z ${intensity} ]; then intensity=100; fi
if [ -z ${diff} ]; then diff=LOW; fi
if [ -z ${ident} ]; then ident=DockerDuco; fi
cat >/"Duino-Coin PC Miner 2.73"/Settings.cfg <<EOL
[PC Miner]
username = ${username}
intensity = ${intensity}
threads = ${threads}
start_diff = ${diff}
donate = 1
identifier = ${ident}
algorithm = DUCO-S1
language = english
soc_timeout = 15
report_sec = 50
discord_rp = y
EOL
python3 /duino-coin/PC_Miner.py > /proc/1/fd/1
