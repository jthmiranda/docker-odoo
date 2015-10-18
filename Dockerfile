FROM ubuntu:14.04.2
MAINTAINER Jonathan Miranda <jonathan.miranda@protonmail.ch>

ENV TZONE "America/El_Salvador"
ENV OE_USER "odoo"
ENV OE_HOME "/opt/$OE_USER"
ENV OE_HOME_EXT "/opt/$OE_USER/$OE_USER-server"

#--------------------------------------------------
# Update Server
#--------------------------------------------------
RUN apt-get update \ 
	&& echo ${TZONE} > /etc/timezone \ 
	&& dpkg-reconfigure -f noninteractive tzdata

#--------------------------------------------------
# System Settings
#--------------------------------------------------
RUN adduser --system --quiet --shell=/bin/bash --home=$OE_HOME --gecos 'ODOO' --group $OE_USER \
	&& mkdir /var/log/$OE_USER \
	&& chown $OE_USER:$OE_USER /var/log/$OE_USER 

#--------------------------------------------------
# Install Basic Dependencies
#--------------------------------------------------
RUN apt-get install -y --no-install-recommends \
	build-essential \
	wget \
	git \
	python-pip \
	python-imaging \
	python-setuptools \
	python-dev \ 
	libxslt-dev \
	libxml2-dev \
	libldap2-dev \
	libsasl2-dev \
	node-less \
	postgresql-server-dev-all \
	libjpeg-dev \
	libfreetype6-dev \
	zlib1g-dev \
	libpng12-dev \
	&& ln -s /usr/include/freetype2 /usr/include/freetype \
	&& wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb \
	&& dpkg --force-depends -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb 2>/dev/null \  
	&& apt-get install -y -f --no-install-recommends \
	&& dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb \
	&& sudo cp /usr/local/bin/wkhtmltopdf /usr/bin \
	&& sudo cp /usr/local/bin/wkhtmltoimage /usr/bin \	
	&& rm -f wkhtmltox-0.12.2.1_linux-trusty-amd64.deb \
	&& wget http://effbot.org/downloads/Imaging-1.1.7.tar.gz \	
	&& tar xzvf Imaging-1.1.7.tar.gz \
	&& rm -f Imaging-1.1.7.tar.gz \
	&& cd Imaging-1.1.7/ \
	&& sed -i "s/TCL_ROOT = None/TCL_ROOT = '\/usr\/lib\/x86_64-linux-gnu'/" setup.py \
	&& sed -i "s/JPEG_ROOT = None/JPEG_ROOT = '\/usr\/lib\/x86_64-linux-gnu'/" setup.py \
	&& sed -i "s/ZLIB_ROOT = None/ZLIB_ROOT = '\/usr\/lib\/x86_64-linux-gnu'/" setup.py \
	&& sed -i "s/TIFF_ROOT = None/TIFF_ROOT = '\/usr\/lib\/x86_64-linux-gnu'/" setup.py \
	&& sed -i "s/FREETYPE_ROOT = None/FREETYPE_ROOT = '\/usr\/lib\/x86_64-linux-gnu'/" setup.py \
	&& sed -i "s/LCMS_ROOT = None/LCMS_ROOT = '\/usr\/lib\/x86_64-linux-gnu'/" setup.py \
	&& python setup.py install \
	&& cd .. \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm 	

#--------------------------------------------------
# Cloning Odoo
#--------------------------------------------------
RUN git clone --depth 1 --single-branch --branch 8.0 https://github.com/odoo/odoo.git $OE_HOME/odoo-server

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
RUN pip install -r $OE_HOME_EXT/requirements.txt \
	&& easy_install suds ofxparse
	
RUN mkdir $OE_HOME/custom && mkdir $OE_HOME/custom/addons

ADD odoo-init /etc/init.d/odoo-server
ADD odoo-server.conf /etc/
ADD start.sh /

RUN chown -R $OE_USER:$OE_USER $OE_HOME/* \
	&& chown $OE_USER:$OE_USER /etc/odoo-server.conf \
	&& chmod 640 /etc/odoo-server.conf \
	&& chmod 755 /start.sh \
	&& chmod 775 /etc/init.d/odoo-server \
	&& chown root: /etc/init.d/odoo-server
	
EXPOSE 8069

USER odoo

ENTRYPOINT ["/start.sh"]  