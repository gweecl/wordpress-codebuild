#!/bin/bash
set -eo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
shopt -s nullglob # https://www.endpoint.com/blog/2016/12/12/bash-loop-wildcards-nullglob-failglob
shopt -s nocasematch # Case Insensitive
shopt -s expand_aliases # Script to check the alias output

# Set working directory / alias
cd $CODEBUILD_SRC_DIR/src
alias wp='php wp-cli.phar --allow-root'
echo "Running script: $(basename -- "$0")"

echo "Install WordPress Plugins..."

echo "Install WordPress Plugin: akismet"
wp plugin install https://downloads.wordpress.org/plugin/akismet.4.1.2.zip
echo "Activate WordPress Plugin: akismet"
if ! $(wp plugin is-active akismet); then
    wp plugin activate akismet
fi

echo "Install WordPress Plugin: advanced-custom-fields"
wp plugin install https://downloads.wordpress.org/plugin/advanced-custom-fields.5.8.1.zip
echo "Activate WordPress Plugin: advanced-custom-fields"
if ! $(wp plugin is-active advanced-custom-fields); then
    wp plugin activate advanced-custom-fields
fi

echo "Install WordPress Plugin: gutenberg"
wp plugin install https://downloads.wordpress.org/plugin/gutenberg.6.1.1.zip
echo "Activate WordPress Plugin: gutenberg"
if ! $(wp plugin is-active gutenberg); then
    wp plugin activate gutenberg
fi