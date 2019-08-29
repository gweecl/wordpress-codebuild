#!/bin/bash
set -eo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
shopt -s nullglob # https://www.endpoint.com/blog/2016/12/12/bash-loop-wildcards-nullglob-failglob
shopt -s nocasematch # Case Insensitive
shopt -s expand_aliases # Script to check the alias output

# Set working directory / alias
cd $CODEBUILD_SRC_DIR/src
alias wp='php wp-cli.phar --allow-root'
echo "Running script: $(basename -- "$0")"

echo "Install WordPress Settings..."

# Environment-specific settings
if [ "x$BUILD_ENV" = "xprod" ]; then
    echo "WordPress configurations for production"
else
    echo "WordPress configurations for development"
    # Debug in dev
    wp config set WP_DEBUG true --raw
fi

# WordPress Salts
# https://api.wordpress.org/secret-key/1.1/salt/
wp config set AUTH_KEY '<SECRET-KEY-HERE>'
wp config set SECURE_AUTH_KEY '<SECRET-KEY-HERE>'
wp config set LOGGED_IN_KEY '<SECRET-KEY-HERE>'
wp config set NONCE_KEY '<SECRET-KEY-HERE>'
wp config set AUTH_SALT '<SECRET-KEY-HERE>'
wp config set SECURE_AUTH_SALT '<SECRET-KEY-HERE>'
wp config set LOGGED_IN_SALT '<SECRET-KEY-HERE>'
wp config set NONCE_SALT '<SECRET-KEY-HERE>'
wp config set WP_CACHE_KEY_SALT '<SECRET-KEY-HERE>'

