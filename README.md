Docker Odoo 8
=============

This project is based on the OCA

Build the image to run on Docker host. 


**Odoo** is the fastest evolving business software in the world. Odoo has a complete suite of business applications covering all business needs, from Website/Ecommerce down to manufacturing, inventory and accounting, all seamlessly integrated. It is the first time ever a software editor managed to reach such a functional coverage.

If you need more about about Odoo, go to: https://www.odoo.com/

#Prerequisites

* Postgres Container (This image come without database, linked through containers is required)

#Usage

##Clone this repo

```
$ git clone https://github.com/jthmiranda/docker-odoo.git && cd docker-odoo
```

##Build Dockerfile

```
$ sudo docker build -t odoo8 .
```

**Note:** the point "." at the end of the command above is necessary to build the image
