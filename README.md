# p0ckit
p0ckit is a Bash-based framework that helps you manage and runs modules/scripts.
It comes with some modules/scripts but you are free to add/modify as you want
(be carefull right now it doesn't have the function to restore them)
# Downloading
To downloading the framework you will need git installed for both Linux/Windows
You can download it from [here](https://git-scm.com/install)
If you already downloaded the repo [go here](#using-the-framework)
## Linux
To download the framework in linux just run the commands below
```bash
git clone https://github.com/tgrd0813/p0ckit.git
cd p0ckit
```
## Windows
```bash
git clone https://github.com/tgrd0813/p0ckit.git
cd p0ckit
```
then [go here](#windows)

# Using the framework
## linux
To use the framework you just need to run:
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

Note:
- The image is based on Debian and includes `bash`, `git`, `python3`, `nmap`, `npm`, `curl`, and `jq`.

# Modules
Right now there is only one it's scanners/ntscan (even tho in the index file are more, those are just to test) which just runs nmap with the ip given.
I plan to add more in the future
