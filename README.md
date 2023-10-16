# CUDA Desktop Docker Image

[![img-github]][link-github]
[![img-docker]][link-docker]
[![img-runpod]][link-runpod]

Ubuntu PyTorch CUDA Docker image with KDE Plasma Desktop & VNC. Ideal for LLM & Deep Learning remote work.

## Base

[CUDA / PyTorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch).

## Content

- KDE Plasma Desktop
- VNC Server
- Visual Studio Code

## Tags

Pytorch tag as per [their official documentation](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags):

- `latest`, `23.09-py3`
- Other tags coming soon.

## Environment Variables

- `VNC_PASSWORD`: Password for VNC connection. Default: `password`.

## Usage

To connect to the container's desktop, you can use VNC.

### VNC Client

Install VNC client on your host machine.

#### Debian/Ubuntu

```sh
sudo apt install tigervnc-viewer
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

```sh

Check [this DigitalOcean's tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-20-04#step-3-connecting-to-the-vnc-desktop-securely) for more details.

## Deployment

### RunPod

[![img-runpod]][link-runpod]

---

[img-docker]: https://img.shields.io/docker/pulls/ivangabriele/cuda-desktop?style=for-the-badge
[img-runpod]: https://img.shields.io/badge/RunPod-Deploy-673ab7?style=for-the-badge
[img-github]: https://img.shields.io/badge/Github-Repo-black?logo=github&style=for-the-badge
[img-github-actions]: https://img.shields.io/github/actions/workflow/status/ivangabriele/docker-cuda-desktop/main.yml?branch=main&style=for-the-badge

[link-docker]: https://hub.docker.com/r/ivangabriele/cuda-desktop
[link-github]: https://github.com/ivangabriele/docker-cuda-desktop
[link-github-actions]: https://github.com/ivangabriele/docker-cuda-desktop/actions/workflows/main.yml
[link-runpod]: https://runpod.io/gsc?template=sihvefhjru&ref=s0k66ov1
