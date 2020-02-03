FROM ubuntu:18.04
MAINTAINER Zach Wasserman <zach@dactiv.llc>

# Inspired by CC0 licensed https://github.com/suchja/wix-toolset
USER root

# Install the necessary packages
RUN dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
	curl \
	unzip \
	ca-certificates \
	wine-stable \
	wine32 \
	winetricks \
	&& rm -rf /var/lib/apt/lists/* \
# Create a separate user for Wine to run as
	&& addgroup --system wine \
	&& adduser \
	--home /home/wine \
	--disabled-password \
	--shell /bin/bash \
	--gecos "non-root user for Wine" \
	--ingroup wine \
	--quiet \
	wine \
	&& mkdir /wix \
	&& chown wine:wine /wix

# Use the separate Wine user
USER wine
ENV HOME=/home/wine WINEPREFIX=/home/wine/.wine WINEARCH=win32
WORKDIR /home/wine

COPY make-aliases.sh /home/wine/make-aliases.sh

# Install a .NET framework and the wix toolset binaries
RUN wine wineboot --init && winetricks --unattended dotnet40 \
	&& mkdir /home/wine/wix \
	&& cd /home/wine/wix \
	&& curl -SL https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip -o wix.zip \
	&& unzip wix.zip \
	&& rm -f wix.zip \
	&& /home/wine/make-aliases.sh \
	&& rm -f /home/wine/make-aliases.sh \
	&& mkdir /home/wine/workdir

ENV PATH="/home/wine/bin:$PATH"
WORKDIR /wix
