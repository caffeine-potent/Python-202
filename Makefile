VENV := $(shell which virtualenv)

ifeq ($(shell which open), "")
OPENCLI := $(shell which xdg-open)
OS=linux
else
OPENCLI := $(shell which open)
OS=mac
endif

VIRTUALENV := ./tensorflow

TF_VERSION := 0.8.0-py3-none-any
TF_CLI := https://storage.googleapis.com/tensorflow/$(OS)/tensorflow-$(TF_VERSION).whl

.PHONY: all
all: jupyter tensorboard

tensorflow/:
  @$(VENV) -p python3 --system-site-packages ./$@
  
$(VIRTUALENV)/bin/pip: upgrade $(VIRTUALENV)  
$(VIRTUALENV)/bin/tensorboard: requirements.txt
$(VIRTUALENV)/bin/jupyter: requirements.txt

requirements.txt: $(VIRTUALENV)/bin/pip
	$< install -r $@
	$< install --upgrade $(TF_URL)

tensorboard: $(VIRTUALENV)/bin/tensorboard
	$(OPENCLI) http://localhost:6006
	tensorflow/bin/tensorboard --logdir=./CH0_DATA

jupyter: $(VIRTUALENV)/bin/jupyter
	$< notebook

upgrade: $(VIRTUALENV)/bin/
	$< install --upgrade pip

clean:
	rm -rf $(VIRTUALENV)
