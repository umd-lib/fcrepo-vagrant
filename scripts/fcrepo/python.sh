# must use 3.6; 3.7 requires a newer version of OpenSSL than CentOS 6 provides
# see https://github.com/pyenv/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib
PYTHON_VERSION=3.6.8

curl -sL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

cat >>$HOME/.bashrc <<END
export PATH="\$HOME/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
export PYENV_VERSION=$PYTHON_VERSION
END

source $HOME/.bashrc

pyenv install $PYTHON_VERSION
pip install stomp.py isodate requests PyYAML
