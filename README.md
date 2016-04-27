Mattermost bot development environment for Vagrant
==================================================

Environment
-----------

- CentOS 7
- Mattermost
- PostgreSQL (for Mattermost)
- Ruby with rbenv (for Lita)
- Node.js (for Hubot)
- Redis (for Lita/Hubot)
- Go (golang)
- and some useful utilities (tig, screen, tmux, direnv, ...)

See `provisioner.sh` for more details.

Prerequirements
---------------

- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) (vagrant plugin)

Install `vagrant-vbguest` plugin.

```
vagrant plugin install vagrant-vbguest
```

How to use
----------

1. Clone this repository.
2. Run `vagrant up`.
