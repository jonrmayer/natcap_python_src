# NatCap Invest System Prequisites
# Ubuntu 14.04



FROM ubuntu:14.04

MAINTAINER Jonathan Mayer jonathan.mayer@ecountability.co.uk

# Update the Ubuntu repository indexes -----------------------------------------------------------------#
RUN apt-get update && apt-get upgrade -y

# Install dependencies - Step 1  ------------------------------------------------------------------------------------------------#
RUN apt-get install -y \
        wget \
        git \
        zip \
        mercurial \
        subversion \
        gdal-bin \
        python-gdal \
        python-qt4 \
        python-numpy \
        python-scipy \
        libgeos-dev

# install pip and needed python packages
RUN wget --no-check-certificate 'http://bootstrap.pypa.io/get-pip.py' && python get-pip.py
RUN pip install --upgrade setuptools
RUN pip install \
    cython \
    shapely \
    python-dateutil \
    pyparsing \
    six \
    pyamg \
    poster \
    nose \
    tox \
    fabric \
    mock


RUN wget https://www.dropbox.com/s/ufvffv2lpbn21vx/dbfpy-2.3.0.tar.gz && pip install dbfpy-2.3.0.tar.gz

RUN mkdir /appdata

VOLUME /appdata
  


