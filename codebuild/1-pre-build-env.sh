#!/bin/bash
set -eo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
shopt -s nullglob # https://www.endpoint.com/blog/2016/12/12/bash-loop-wildcards-nullglob-failglob
shopt -s nocasematch # Case Insensitive
shopt -s expand_aliases # Script to check the alias output

# Issue: 
# https://github.com/aws/aws-codebuild-docker-images/issues/205
echo "Reinstall PHP Version 7.2..."
echo "Installing dependencies..."
rm -f /usr/local/bin/php*
rm -f /usr/local/bin/phar*
rm -f /usr/local/bin/pear*
rm -f /usr/local/bin/pecl*
apt-get update 
apt-get install -y jq git php7.2 php7.2-mysql php7.2-zip php7.2-xml php7.2-mbstring mysql-client

echo "Add .htaccess for Apache Server..."
# echo '
# # BEGIN WordPress
# <IfModule mod_rewrite.c>
# RewriteEngine On
# RewriteBase /
# RewriteRule ^index\.php$ - [L]
# RewriteCond %{REQUEST_FILENAME} !-f
# RewriteCond %{REQUEST_FILENAME} !-d
# RewriteRule . /index.php [L]
# </IfModule>
# # END WordPress
# ' >> .htaccess
if [ "x$BUILD_ENV" = "xprod" ]; then
    cp ./codebuild/prod/.htaccess .htaccess
else
    cp ./codebuild/dev/.htaccess .htaccess
fi

