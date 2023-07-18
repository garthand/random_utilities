#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

update_system () (
    # Update system
    sudo apt update -y
    sudo apt full-upgrade -y
)

install_vim () (
    # Replace vim-tiny with vim
    sudo apt purge vim-tiny -y
    sudo apt install vim -y
)

install_pyenv() (
    # Install pyenv dependencies
    sudo apt install curl git -y
    pyenv_installed=$(which pyenv || true)
    if [ "$pyenv_installed" == "" ]
    then
        curl https://pyenv.run | bash
    fi
    count=$(grep -c pyenv ~/.bashrc || true)
    if [ "$count" == 0 ]
    then
        {
            # shellcheck disable=SC2016
            echo 'export PYENV_ROOT="$HOME/.pyenv"'
            # shellcheck disable=SC2016
            echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
            # shellcheck disable=SC2016
            echo 'eval "$(pyenv init -)"'
        } >> ~/.bashrc
    fi
)

install_latest_python() (
    # Install Python dependencies
    sudo apt install gcc pkg-config make zlib1g-dev libssl-dev libbz2-dev libncurses-dev libffi-dev libreadline-dev libsqlite3-dev tk-dev liblzma-dev -y
    # Install the latest version of Python
    latest_python_version=$(~/.pyenv/bin/pyenv install --list|sed 's/\ //g'|grep -Ev "[Aa-Zz]"|tail -1)
    ~/.pyenv/bin/pyenv install "$latest_python_version"
    ~/.pyenv/bin/pyenv global "$latest_python_version"
)

main() (
    update_system
    install_vim
    install_pyenv
    install_latest_python
)

main
