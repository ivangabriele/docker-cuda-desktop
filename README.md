# Docker Image :: Ubuntu KDE Plasma Desktop with PyTorch, CUDA & VNC

[![img-github]][link-github]
[![img-docker]][link-docker]
[![img-runpod]][link-runpod]

Ideal for LLM & Deep Learning remote work.

## Screenshot

![CUDA Desktop](https://raw.githubusercontent.com/ivangabriele/docker-cuda-desktop/main/screenshot.png)

## Base

Based on [PyTorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch) (including Ubuntu & CUDA).

## Content

- KDE Plasma Desktop
- VNC Server (port `5900`)

and:

- Firefox (ESR)
- Kitty (terminal)
- Sublime Text
- Visual Studio Code (must be run with `--no-sandbox` flag)
- zsh (with oh-my-zsh)

## Tags

Pytorch tag as per [their official documentation](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags):

- PyTorch 23.09-py3
  - `latest`

## Environment Variables

- `VNC_PASSWORD`: Password for VNC connection. Default: `password`.
- `VNC_SCREEN_SIZE`: Screen size. Default: `1920x1080`.

## Usage

To connect to the container's desktop, you can use any VNC client.

> [!NOTE]  
> You will have a wide list of errors during startup but you can ignore them.
> Simulating a full X server is not an easy task.

Your server will be ready once you see this line in the logs:

```bash
[...]
cuda-desktop-server  | Plasma Shell startup completed
[...]
```

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
