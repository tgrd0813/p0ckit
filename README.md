# p0ckit
p0ckit is a small Bash-based tool that manages and runs modules/scripts.

## Docker

This repository includes a `Dockerfile` so you can run `p0ckit` inside a container.

### Build the image

```bash
docker build -t p0ckit:latest .
```

### Run (interactive)

Basic interactive run (mount current repo, optional):

```bash
docker run --rm -it -v "$(pwd):/opt/p0ckit" p0ckit:latest
```

If your workflows use network scanning (e.g., `nmap`) you may want to run with host networking and network capabilities (Linux only):

```bash
sudo docker run --rm -it --network host --cap-add=NET_RAW --cap-add=NET_ADMIN -v "$(pwd):/opt/p0ckit" p0ckit:latest
```

Notes:
- The image is based on Debian and includes `bash`, `git`, `python3`, `nmap`, `npm`, `curl`, and `jq`.
- Some features (like system package installation via `pkg_install`) require a package manager and/or `sudo`; the container runs as root by default for simplicity.

ps: this is readme.md file is ai generated I will update it when I finish most of the tool and add some modules