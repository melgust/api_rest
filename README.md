# Simple Point Of Sale RESTful services
A simple api for RESTful services using Silex framework

# Information
This POS based from
https://github.com/alangumer/pos-admin

# Installation
Activate rewrite mode on your server and create a .htaccess file for project, add this lines, change posapi for your custom name

FallbackResource /project/index.php
<IfModule mod_rewrite.c>
    Options -MultiViews
    RewriteEngine On
    #RewriteBase /posapi/
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>

# Config params
Change your params for database in file /src/app.php
