FROM ubuntu:latest
MAINTAINER Rich Wareham <rich.kicad-docker@richwareham.com>

RUN apt-get -y update && apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:js-reynaud/kicad-4 && \
	apt-get -y update && apt-get -y install kicad


