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
RUN apt-get install -y \
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
	postgresql-server-dev-all -y
	

#--------------------------------------------------
# Cloning Odoo
#--------------------------------------------------
RUN git clone --depth 1 --single-branch --branch 8.0 git@github.com:OCA/OCB.git $OE_HOME/odoo-server

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
RUN pip install -r $OE_HOME_EXT/requirements.txt \
	&& easy_install pyPdf vatnumber pydot psycogreen suds ofxparse
	
RUN mkdir $OE_HOME/custom && mkdir $OE_HOME/custom/addons

ADD odoo-init /etc/init.d/odoo-server
ADD odoo-server.conf /etc/

RUN chown -R $OE_USER:$OE_USER $OE_HOME/* \
	&& chown $OE_USER:$OE_USER /etc/odoo-server.conf \
	&& chmod 640 /etc/odoo-server.conf \
	&& chmod 775 $OE_HOME_EXT/start.sh	\
	&& chmod 775 /etc/init.d/odoo-server \
	&& chown root: /etc/init.d/odoo-server

EXPOSE 8069

CMD "/bin/sh" "-c" "service odoo-service start"