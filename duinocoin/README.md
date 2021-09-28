## DuinoCoin mining using Docker.
#### Supports both AVR and PC.

```sh
version: "3.9"
services:
    DuinoCoinAVR:
        container_name: DuinoCoinAVR
        image: lasvanes/duinocoin
        restart: unless-stopped
        environment:
          username: DockerDuco
          ident: DockerUNO
          mode: AVR
          devices: /dev/ttyUSB0,/dev/ttyUSB1,/dev/ttyUSB2,/dev/ttyUSB3,/dev/ttyACM0,/dev/ttyACM1
        devices:
          - "/dev/ttyUSB0:/dev/ttyUSB0"
          - "/dev/ttyUSB1:/dev/ttyUSB1"
          - "/dev/ttyUSB2:/dev/ttyUSB2"
          - "/dev/ttyUSB3:/dev/ttyUSB3"
          - "/dev/ttyACM0:/dev/ttyACM0"
          - "/dev/ttyACM1:/dev/ttyACM1"
    DuinoCoinPC:
        container_name: DuinoCoinPC
        image: lasvanes/duinocoin
        restart: unless-stopped
        environment:
          username: DockerDuco
          threads: 4
          intensity: 100
          diff: LOW
          ident: DockerPi4
```


Docker DuinoCoin [GitHub](https://github.com/Lanjelin/docker-tinker/tree/main/duinocoin).

More on [DuinoCoin](https://github.com/revoxhere/duino-coin#readme)
