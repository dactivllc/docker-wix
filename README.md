# Docker Wix

This repository contains the Docker build files for a container that enables
building Windows MSI packages from any system supporting Docker.

Want to build MSI packages on macOS or Linux? Read on.

## Docker Hub

The precompiled images are available at
[hub.docker.com/r/dactiv/wix](https://hub.docker.com/r/dactiv/wix).

``` sh
docker pull dactiv/wix
```

## Requirements

The only requirement for building or running these containers is a working
installation of [Docker](https://www.docker.com/products/docker-desktop).

## Usage

The container build exposes each of the WiX Toolset executables in the `PATH`.
This means that running WiX's `candle.exe` is simple as:

``` sh
docker run --rm dactiv/wix candle
```

In order to do anything useful with WiX, you need to mount a volume to expose
the necessary files to the WiX tools. The default working directory of the
container is `/wix`, so it is easiest to mount the host's working directory to
that path:

``` sh
docker run --rm -v $(pwd):/wix dactiv/wix candle sample.wxs
```

## Example

A small sample configuration is provided in [`./sample`](./sample). To build
the `sample.msi`, run the following commands:

``` sh
cd sample
docker run --rm -v $(pwd):/wix dactiv/wix candle sample.wxs
docker run --rm -v $(pwd):/wix dactiv/wix light sample.wixobj -sval
```

The `sample.msi` will now be in the `sample` directory.

## Known Issues

### `light` fails when running validation

``` sh
docker run --rm -v $(pwd):/wix dactiv/wix light sample.wixobj
Windows Installer XML Toolset Linker version
Copyright (c) .NET Foundation and contributors. All rights reserved.

light.exe : error LGHT0216 : An unexpected Win32 exception with error code 0x65B occurred: Function failed.
```

The workaround for this is to disable validation with the `-sval` flag:

``` sh
docker run --rm -v $(pwd):/wix dactiv/wix light sample.wixobj -sval
```
