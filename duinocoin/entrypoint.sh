#!/bin/bash
if ! [ -e /versions ]; then
    #Firstrun, fetching versions
    avrver=$(sed -n 3p /duino-coin/AVR_Miner.py | awk '{split($0,a,"Miner");print a[2]}' | awk '{split($0,a,"©");print a[1]}' | xargs)
    pcver=$(sed -n 3p /duino-coin/PC_Miner.py | awk '{split($0,a,"Miner");print a[2]}' | awk '{split($0,a,"©");print a[1]}' | xargs)
    mkdir "Duino-Coin AVR Miner ${avrver}"
    mkdir "Duino-Coin PC Miner ${pcver}"
    echo "${avrver}-${pcver}" > versions
    
    # Removing terminal title from AVR code, as it doesnt work with docker logs.
    sed -i "s/print('\\\33]0;' + title + '\\\a', end='')//" /duino-coin/AVR_Miner.py
    #sed -i "s/\\\33]0\;//" /duino-coin/AVR_Miner.py
fi
AVR=$(cat /versions | awk '{split($0,a,"-");print a[1]}')
PC=$(cat /versions | awk '{split($0,a,"-");print a[1]}')

# Common Vars
if [ -z ${username} ]; then username=DockerDuco; fi
if [ -z ${ident} ]; then ident=DockerDuco; fi

#AVR Miner
if [ -z ${mode} ]; then mode=PC; fi
if [ ${mode} == "AVR" ]; then
  if [ -n ${devices} ]; then
    cat >/"Duino-Coin AVR Miner ${AVR}"/Settings.cfg <<EOL
    [AVR Miner]
    username = ${username}
    avrport = ${devices}
    donate = 1
    language = english
    identifier = ${ident}
    debug = n
    soc_timeout = 45
    avr_timeout = 4
    discord_presence = y
    periodic_report = 60
    shuffle_ports = y
EOL
    echo "Running AVR Miner" > /proc/1/fd/1
    echo "Running AVR Miner, output in logs."
    python3 /duino-coin/AVR_Miner.py > /proc/1/fd/1
  else
    echo "Missing USB-device list. Exiting." > /proc/1/fd/1
    exit 1
  fi

else
# PC Miner
  if [ -z ${threads} ]; then threads=$(grep -c processor /proc/cpuinfo); fi
  if [ -z ${intensity} ]; then intensity=100; fi
  if [ -z ${diff} ]; then diff=LOW; fi
  cat >/"Duino-Coin PC Miner ${PC}"/Settings.cfg <<EOL
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
  echo "Running PC Miner" > /proc/1/fd/1
  echo "Running PC Miner, output in logs."
  python3 /duino-coin/PC_Miner.py > /proc/1/fd/1
fi
