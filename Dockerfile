FROM i386/alpine:3.11.3
MAINTAINER Zach Wasserman <zach@dactiv.llc>

# Wine 32Bit for running EXE
RUN apk add --no-cache wine=4.0.3-r0 freetype=2.10.1-r1 wget \
# Create a separate user for Wine
	&& addgroup --system wine \
	&& adduser \
	--home /home/wine \
	--disabled-password \
	--shell /bin/bash \
	--gecos "non-root user for Wine" \
	--ingroup wine \
	wine \
	&& mkdir /wix \
	&& chown wine:wine /wix

# Use the separate Wine user
USER wine
ENV HOME=/home/wine WINEPREFIX=/home/wine/.wine WINEARCH=win32 PATH="/home/wine/bin:$PATH" WINEDEBUG=-all
WORKDIR /home/wine

COPY make-aliases.sh /home/wine/make-aliases.sh

# Install .NET framework and WiX Toolset binaries
RUN wine wineboot && \
	wget https://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi -nv -O mono.msi \
	&& wine msiexec /i mono.msi \
	&& rm -f mono.msi \
	&& wget https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip -nv -O wix.zip \
	&& mkdir wix \
	&& unzip wix.zip -d wix \
	&& rm -f wix.zip \
	&& /home/wine/make-aliases.sh \
	&& rm -f /home/wine/make-aliases.sh

WORKDIR /wix
