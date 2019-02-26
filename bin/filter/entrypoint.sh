#!/usr/bin/env bash

# custom path for files to override default files
custom_path="$GITHUB_WORKSPACE/.github/bin"
main_script="/usr/local/bin/branch"

if [[ -d "$custom_path" ]]; then
    rsync -av "$custom_path/" /usr/local/bin/
    RUN chmod +x -R /usr/local/bin/
fi

bash "$main_script"
