FROM appcontainers/ubuntu:trusty

MAINTAINER Mika Yoshimura myoshimura080822@gmail.com

ADD vimrc.local /tmp/

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y make && \
    apt-get install -y zip && \
    apt-get install -y python-pip && \
    apt-get install -y python-dev && \
    apt-get install -y python-matplotlib && \
    apt-get install -y python-numpy && \
    apt-get install -y python-scipy && \
    apt-get install -y python-reportlab && \
    apt-get install -y -q wget && \
    apt-get install -y tree zsh && \
    apt-get install -y libjson-xs-perl && \
    apt-get install -y libsvg-perl && \
    apt-get install -y zlib1g-dev libncurses5-dev && \
    apt-get install -y inkscape && \
    apt-get clean

# Install OH-MY-ZSH
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /tmp/.oh-my-zsh  && \
    cp /tmp/.oh-my-zsh/templates/zshrc.zsh-template /etc/zsh/zshrc && \
    sed -i -e "9i TERM=xterm" /etc/zsh/zshrc && \
    sed -i "s/robbyrussell/candy/" /etc/zsh/zshrc && \
# setting vimrc
    cp /tmp/vimrc.local /etc/vim/ && \
    cp -r /tmp/.oh-my-zsh/ /root/ && \
# setting SIRV Suite
    git clone https://github.com/sirvsuite-support/sirvsuite && \
    cd sirvsuite/tools && \
    pip install xmltodict && \
    cpan Math::Amoeba && \
    chmod a+x *.pl && \
    chmod a+x *.sh && \
# Install cufflinks
    wget http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz && \
    tar -xzvf cufflinks-2.2.1.Linux_x86_64.tar.gz && \ 
# Install samtools
    wget https://sourceforge.net/projects/samtools/files/samtools/1.3.1/samtools-1.3.1.tar.bz2 && \
    bunzip2 samtools-1.3.1.tar.bz2 && \
    tar -xvf samtools-1.3.1.tar && \
    cd samtools-1.3.1 && \
    make && \
    cd /sirvsuite/tools && \
# Install bedtools
    wget https://github.com/arq5x/bedtools2/releases/download/v2.25.0/bedtools-2.25.0.tar.gz && \
    tar -zxvf bedtools-2.25.0.tar.gz && \
    cd bedtools2 && \
    make

ENV PATH="/sirvsuite/tools/bedtools2/bin/:/sirvsuite/tools/samtools-1.3.1/:/sirvsuite/tools/cufflinks-2.2.1.Linux_x86_64/:/usr/local/bin:${PATH}"

VOLUME ["/export/", "/data/", "/var/lib/docker"]


