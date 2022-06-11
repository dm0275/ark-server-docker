# Ark Docker Image

## Build Image
Run the following Make task to build the image
```bash
make build
```

## Run server
Export the following environment variables before running the server/image:
```bash
export ARK_HOME=<ARK_SERVER_DIR> \
    JOIN_PASSWORD=<JOIN_PASS> \
    ADMIN_PASSWORD=<ADMIN_PASS> \
    SERVER_MAP=<SERVER MAP, e.g. TheIsland> \
    SERVER_NAME=<SERVER_NAME>
```
Then run the folllowing task
```
make run
```

## Admin & Cheat commands
Once in-game, press `tab` to bring up the console and type:
```
enablecheats <ADMIN_PASS>
```
The full list of commands and cheats can be found here https://ark.fandom.com/wiki/Console_commands
