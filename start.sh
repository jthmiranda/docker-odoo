#!/bin/sh
set -e

echo "Starting odoo-server"
/opt/odoo/odoo-server/openerp-server -c /etc/odoo-server.conf  
