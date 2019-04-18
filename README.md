# Coder Runner

This project provides a couple of utilities to install and run VS Code on a remote server through the [Coder](https://coder.com) project.

## TL;DR

Install coder on **Linux** by pulling the latest version and create self-signed certificates.

```bash

git clone https://github.com/edoardo849/coder-runner
cd ./coder-runner

chmod +x install.sh
./install.sh

```
Run VS Code

```bash
chmod +x coder.sh
./coder.sh

```

## Description

The installer will attempt to find the latest version of coder by querying the Github's tags API. It will then pull the latest binary and load the configuration options in the `~/.config/coder.conf` file.

In order to modify the way that coder is launched, just edit `~/.config/coder.conf`.
