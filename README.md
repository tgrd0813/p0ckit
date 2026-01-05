# p0ckit
p0ckit is a Bash-based framework that helps you manage and runs modules/scripts.
It comes with some modules/scripts but you are free to add/modify as you want
(be carefull right now it doesn't have the function to restore them)
# Using the fw

## linux
To use the fw you just need to run:
```bash
bash p0ckit.sh
```
OR
```bash
chmod +x p0ckit.sh
./p0ckit.sh
```

## Windows/Docker
To run the fw in Windows you need to have Docker installed.
After you install it you can ether use the GUI or the commands below
(they are the same if you want to run the docker image in linux)

## Build the image

```bash
docker build -t p0ckit .
```
## Run the image
```bash
docker run -i -t p0ckit
```

Notes:
- The image is based on Debian and includes `bash`, `git`, `python3`, `nmap`, `npm`, `curl`, and `jq`.
- Some features (like system package installation via `pkg_install`) require a package manager and/or `sudo`; the container runs as root by default for simplicity.

# Modules
Right now there is only one it has its scanners/ntscan (even tho in the index file are more those where just to test) which just runs nmap with the ip given.
I plan to add more in the future

# To do:
- add more modules
- add a show options and better help menu for modules