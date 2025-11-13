FROM texlive/texlive:latest

RUN apt update && apt -y upgrade
RUN apt install -y inkscape

WORKDIR /workdir