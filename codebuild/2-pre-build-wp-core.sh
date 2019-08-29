#!/bin/bash
set -eo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
shopt -s nullglob # https://www.endpoint.com/blog/2016/12/12/bash-loop-wildcards-nullglob-failglob
shopt -s nocasematch # Case Insensitive
shopt -s expand_aliases # Script to check the alias output

# Set working directory / alias
cd $CODEBUILD_SRC_DIR/src
alias wp='php wp-cli.phar --allow-root'
echo "Running script: $(basename -- "$0")"

echo "Retrieve values from AWS Secret Manager..."
DB_HOST=$(aws secretsmanager get-secret-value --secret-id $SECRET_MANAGER_ARN --query 'SecretString' | jq -r 'fromjson | .DatabaseHost')
DB_PORT=$(aws secretsmanager get-secret-value --secret-id $SECRET_MANAGER_ARN --query 'SecretString' | jq -r 'fromjson | .DatabasePort')
DB_NAME=$(aws secretsmanager get-secret-value --secret-id $SECRET_MANAGER_ARN --query 'SecretString' | jq -r 'fromjson | .DatabaseName')
DB_USERNAME=$(aws secretsmanager get-secret-value --secret-id $SECRET_MANAGER_ARN --query 'SecretString' | jq -r 'fromjson | .DatabaseUserName')
DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id $SECRET_MANAGER_ARN --query 'SecretString' | jq -r 'fromjson | .DatabasePassword')

echo "Installing WordPress CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

echo "Install Wordpress core files..."
wp core download --locale=en_US --skip-content

echo "Install WordPress Database Configurations..."
wp config create --dbhost=$DB_HOST:$DB_PORT --dbname=$DB_NAME --dbuser=$DB_USERNAME --dbpass=$DB_PASSWORD

if ! $( wp core is-installed ); then
    echo "Install WordPress Database..."
    # Change Options value
    wp core install --url='http://example-elb-url.ap-southeast-1.elb.amazonaws.com/' \
        --title='WordPress' \
        --admin_user='admin' \
        --admin_password='admin' \
        --admin_email='admin@admin.com' \
        --skip-email
fi