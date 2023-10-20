# CUDA Desktop Docker Image

[![img-github]][link-github]
[![img-docker]][link-docker]
[![img-runpod]][link-runpod]

Ubuntu PyTorch CUDA Docker image with KDE PLasma Desktop & VNC. Ideal for LLM & Deep Learning remote work.

> [!WARNING]  
> This is a work in progress.

## Base

Based on [PyTorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch) (including Ubuntu & CUDA).

## Content

- KDE Plasma Desktop
- VNC Server (port `5900`)

and:

- Falkon (default browser)
- Kitty
- Sublime Text
- Visual Studio Code (must be run with `--no-sandbox` flag)
- zsh

## Tags

Pytorch tag as per [their official documentation](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags):

- PyTorch 23.09-py3
  - `latest`

## Environment Variables

- `USER_PASSWORD`: Password for both `sudo` commands and VNC connection. Default: `password`.

## Usage

To connect to the container's desktop, you can use VNC.

### VNC Client

Install VNC client on your host machine.

#### Debian/Ubuntu

```sh
sudo apt install vinagre
```

### Secure VNC Connection

> [!IMPORTANT]  
> VNC itself doesn’t use secure protocols when connecting.
> To securely connect to your server, you’ll establish an SSH tunnel
> and then tell your VNC client to connect using that tunnel rather than making a direct connection.

```sh
ssh -L 59000:localhost:[PUBLIC_5901_PORT_BINDING] -C -N -l root [YOUR_SERVER_IP]
```

VNC Server is listening on port `5901` in this image but you or your PaaS may bind this port to another public one.
`[PUBLIC_5901_PORT_BINDING]` should be replaced by the public port binded to the container's `5901` port.

Check [this DigitalOcean's tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-20-04#step-3-connecting-to-the-vnc-desktop-securely) for more details.

## Deployment

### RunPod

[![img-runpod]][link-runpod]

## Thanks

- [@ms-jpq](https://github.com/ms-jpq)
  for [ms-jpq/kde-in-docker](https://github.com/ms-jpq/kde-in-docker)
- [Selkies](https://github.com/selkies-project)
  for [selkies-project/docker-nvidia-glx-desktop](https://github.com/selkies-project/docker-nvidia-glx-desktop)

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/cuda-desktop?style=for-the-badge
[img-runpod]: https://img.shields.io/badge/RunPod-Deploy-673ab7?style=for-the-badge
[img-github]: https://img.shields.io/badge/Github-Repo-black?logo=github&style=for-the-badge
[img-github-actions]: https://img.shields.io/github/actions/workflow/status/ivangabriele/docker-cuda-desktop/main.yml?branch=main&style=for-the-badge

[link-docker]: https://hub.docker.com/r/ivangabriele/cuda-desktop
[link-github]: https://github.com/ivangabriele/docker-cuda-desktop
[link-github-actions]: https://github.com/ivangabriele/docker-cuda-desktop/actions/workflows/main.yml
[link-runpod]: https://runpod.io/gsc?template=fc1g5zbii8&ref=s0k66ov1
