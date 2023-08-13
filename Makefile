IMG_DATE = $(shell date +%Y-%m-%d)

PI_GEN_DEPLOY_DIR = deploy
BASE_IMG_FILENAME = $(PI_GEN_DEPLOY_DIR)/$(IMG_DATE)-$(IMG_NAME).img

PACKER = $(shell which packer)
PACKER_CONFIG_HOME = $(HOME)
PACKER_DIR ?= packer

$(BASE_IMG_FILENAME):
	sudo -E ./build.sh

%.sha256: %
	shasum -a 256 $< | sudo tee $@

$(phony packvars): $(BASE_IMG_FILENAME) $(BASE_IMG_FILENAME).sha256
	cat >packer/variables.auto.pkrvars.hcl <<EOF
source_iso_checksum = ../$(BASE_IMG_FILENAME)
source_iso_url = $$(cut -d' ' -f1 < ../$(BASE_IMG_FILENAME).sha256)
operator_user_name = ../$(PI_GEN_DEPLOY_DIR)
output_directory = $(FIRST_USER_NAME)
EOF

$(phony packsetup): packvars
	cd packer && $(PACKER) init .

$(phony packbuild): packsetup
	PACKER_CONFIG_DIR=$(PACKER_CONFIG_HOME) sudo -E $(PACKER) build .

$(phony all): packbuild

$(phony clean):
	sudo rm -rf $(PI_GEN_DEPLOY_DIR)/*.img