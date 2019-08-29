#!/bin/bash
set -eo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
shopt -s nullglob # https://www.endpoint.com/blog/2016/12/12/bash-loop-wildcards-nullglob-failglob
shopt -s nocasematch # Case Insensitive
shopt -s expand_aliases # Script to check the alias output

# Set working directory / alias
cd $CODEBUILD_SRC_DIR/src
alias wp='php wp-cli.phar --allow-root'
echo "Running script: $(basename -- "$0")"

echo "Install WordPress Themes..."

echo "Install WordPress Default Theme: twentynineteen"
wp theme install twentynineteen 

