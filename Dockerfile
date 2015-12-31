# PostGIS 2.1.2
# Ubuntu 14.04

# CREDITS: Based on http://www.peterstratton.com/2014/04/how-to-install-postgis-2-dot-1-and-postgresql-9-dot-3-on-ubuntu-servers/

FROM ubuntu:14.04

MAINTAINER Jonathan Mayer jonathan.mayer@ecountability.co.uk

# Update the Ubuntu repository indexes -----------------------------------------------------------------#
RUN apt-get update && apt-get upgrade -y

# Install dependencies - Step 1  ------------------------------------------------------------------------------------------------#
RUN apt-get install -y flex bison libfcgi-dev libxml2 libxml2-dev\
curl openssl autoconf apache2 python-software-properties subversion\
libmozjs185-dev python-dev build-essential

# Add UbuntuGIS repository and update - Step 2  ----------------------------------------------------------------------------------------#
RUN add-apt-repository ppa:ubuntugis/ppa
RUN apt-get update

# Install GDAL - Step 3  ----------------------------------------------------------------------------------------#
RUN apt-get install libgdal1-dev


# Build Zoo WPS  from source -------------------------------------------------------------------------------------#


RUN cd /usr/local/src && \
   svn checkout http://www.zoo-project.org/svn/trunk zoo && \
   cd /usr/local/src/zoo/thirds/cgic206 && \
   sed "s:lib64:lib:g" -i Makefile && \
   cd /usr/local/src/zoo/zoo-project/zoo-kernel && \
   autoconf && \
   ./configure --with-python --with-pyvers=2.7 --with-js=/usr/ --with-xsltconfig=/usr/bin/xslt-config && \
   make && \
   make install 
# Build Zoo WPS  from source -------------------------------------------------------------------------------------#   
   cp main.cfg /usr/lib/cgi-bin && \
   cp zoo_loader.cgi /usr/lib/cgi-bin && \
   chown -R www-data:www-data /usr/lib/cgi-bin
  

# Install PostGIS -----------------------------------------------------------------------------------------------------#
RUN apt-get -y -q install postgresql-9.3-postgis-2.1

# Variables -----------------------------------------------------------------------------------------------------------#
ENV POSTGIS_GDAL_ENABLED_DRIVERS ENABLE_ALL
ENV POSTGIS_ENABLE_OUTDB_RASTERS 1

# Modify config files -------------------------------------------------------------------------------------------------#
# Allow remote connections to the database and listen to all addresses
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Setup supervisor ----------------------------------------------------------------------------------------------------#
RUN mkdir -p /var/log/supervisor && \
    locale-gen en_US en_US.UTF-8
ADD supervisord.conf /etc/supervisor/conf.d/

# Add startup script --------------------------------------------------------------------------------------------------#
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose the PostgreSQL port ------------------------------------------------------------------------------------------#
EXPOSE 5432

# Add VOLUMEs to for inspection, datastorage, and backup --------------------------------------------------------------#
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/lib/ckan/default", "/var/log/supervisor"]

CMD ["/usr/local/bin/startup.sh"]
