# bcui
UI front-end

```
├── Dockerfile - The file to build our image and telegram container
├── README.md - this file
├── backup.sh - backup script to any directory somewhere (e.g. gdrive, dropbox, etc.)
├── build.sh - build the docker image
├── common.sh - common env variables go here, keep your local secrets here as well
├── python-telegram-bot - a submodule we need to install telegram python bot
├── python-telegram-bot.tar.gz - tar ball above directory for docker
├── run.sh - run the docker image
└── update-permission - fix permission in docker container
```

To build docker image
```
./build.sh
```

To run the image
```
TELEGRAM_TOKEN_API=YOUR_BOT_TOKEN_STRING ./run.sh
```

