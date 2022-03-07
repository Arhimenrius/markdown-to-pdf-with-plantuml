FROM ubuntu:impish

# combine into one run command to reduce image size
# Using Finnish mirror due of the CI/CD pipeline
RUN sed 's|archive.ubuntu.com/ubuntu/|www.nic.funet.fi/pub/mirrors/archive.ubuntu.com/|' -i /etc/apt/sources.list
  && apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y perl wget libfontconfig1 pandoc python3 python3-pip plantuml
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh  && \
    apt-get clean
ENV PATH="${PATH}:/root/bin"
RUN tlmgr install xetex
RUN fmtutil-sys --all

# install only the packages you need
# this is the bit which fails for most other methods of installation
RUN tlmgr install xcolor pgf fancyhdr parskip babel-english units lastpage mdwtools comment psnfss adjustbox collectbox

RUN python3 -m pip install pandoc-plantuml-filter

# Create directory whlere content will be stored
RUN mkdir -p /var/doc

COPY build.sh relative_to_absolute_path.py /var/

WORKDIR /var/build
