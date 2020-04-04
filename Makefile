SHELL=bash

.DEFAULT_GOAL := env
.PHONY := osdep env osdeplinux osdepmac venv dep pip



#########################################
##### DEVELOPMENT ENVIRONMENT SETUP #####
#########################################
# Store OS in a variable
OS := $(shell uname -s)
# Only supporting Linux and Mac
OSDEP_TARGET = osdeplinux
ifneq ($(OS), Linux)
    OSDEP_TARGET = osdepmac
endif

osdep: $(OSDEP_TARGET)
# Before calling this task from pipelines, beware that osdep can trigger priviledge elevation dialogs and break the
# CI build
env: venv dep

osdepmac:
	brew install python3 pyenv-virtualenv unzip

osdeplinux:
	sudo apt-get install python3-pip virtualenv unzip

venv:
	rm -rf .env
	virtualenv -p python3 .env
	source .env/bin/activate && pip install --upgrade pip

dep: pip
	# Install role dependencies
	PIP_CONFIG_FILE=./env/pip.conf .env/bin/pip install -r requirements.txt --upgrade
	ansible-galaxy role install fcastello.firewall

pip:
	echo "[global]" > .env/pip.conf
	echo "no-cache-dir = false" >> .env/pip.conf
	echo "index-url = https://pypi.python.org/simple" >> .env/pip.conf

################################
##### AUTOMATION PLAYBOOKS #####
################################

# Get router facts
router-facts:
	source .env/bin/activate && ansible router -m setup

# Deploy all router configurations
router:
	source .env/bin/activate && ansible-playbook router.yml

# Deploy firewall configuration to router
firewall:
	source .env/bin/activate && ansible-playbook router.yml --tags=firewall
