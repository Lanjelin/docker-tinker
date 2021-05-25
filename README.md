## quizmaster
Image and docker-compose based on [nymanjens/quizmaster](https://github.com/nymanjens/quizmaster), smaller (192.5MB), supports bind mount and UID/GID.

## mollusc + mongodb
An attempt to make [kevthehermit/mollusc](https://github.com/kevthehermit/mollusc) work, and it somewhat does. Includes an instance of mongodb for use with [cowrie/cowrie](https://github.com/cowrie/cowrie). `cowrie.cfg` is to be configured to connect to the mongodb instance in this container (no authentication), and requires `pip install pymongo`.
