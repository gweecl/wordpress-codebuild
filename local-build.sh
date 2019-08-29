#!/bin/bash
set -eo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
shopt -s nullglob # https://www.endpoint.com/blog/2016/12/12/bash-loop-wildcards-nullglob-failglob
shopt -s nocasematch # Case Insensitive
shopt -s expand_aliases # Script to check the alias output

# Set working directory / alias
cd ./src
alias wp='php wp-cli.phar --allow-root'
echo "Running script: $(basename -- "$0")"

echo "Installing WordPress CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

if ! $( wp core is-installed ); then

    echo "Install Wordpress core files..."
    wp core download --locale=en_US --skip-content

    # Refer to docker-compose.local.yml
    echo "Update WordPress Database Configurations..."
    wp config create --dbhost='127.0.0.1:3306' --dbname='wordpress' --dbuser='root' --dbpass='pw'

    echo "Install WordPress Database..."
    # Change Options value
    wp core install --url='http://localhost/' \
        --title='WordPress' \
        --admin_user='admin' \
        --admin_password='admin' \
        --admin_email='admin@admin.com' \
        --skip-email

    echo "Install WordPress Settings..."
    wp config set WP_DEBUG true --raw
    # Options
    wp option update permalink_structure '/%postname%/'
    wp option update timezone_string 'Asia/Singapore'

    echo "Install WordPress Theme..."
    wp theme install twentynineteen

    echo "Install WordPress Plugins..."
    wp plugin install https://downloads.wordpress.org/plugin/akismet.4.1.2.zip
    wp plugin install https://downloads.wordpress.org/plugin/advanced-custom-fields.5.8.1.zip
    wp plugin install https://downloads.wordpress.org/plugin/gutenberg.6.1.1.zip

else
    echo "WordPress Installed..."
fi
