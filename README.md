Docker Odoo 8
=============

This project is based on the OCA

**Odoo** is the fastest evolving business software in the world. Odoo has a complete suite of business applications covering all business needs, from Website/Ecommerce down to manufacturing, inventory and accounting, all seamlessly integrated. It is the first time ever a software editor managed to reach such a functional coverage.

If you need more about about Odoo, go to: https://www.odoo.com/

#Prerequisites

* docker-compose 1.4 or later

#Usage

##Clone this repo

```
$ git clone https://github.com/jthmiranda/docker-odoo.git && cd docker-odoo
```

##Build those Dockerfile using docker-compose

```
$ docker-compose -p ecommerce up -d
```

 Wait for build those image a few minutes or depending your internet speed!
 
 Go to http://localhost:8007 

**admin password:** superadminpassword