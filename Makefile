PI_GEN_DEPLOY_DIR = deploy
IMG_NAME = $(shell bash -c 'source ./config; echo $$IMG_NAME')
BASE_IMG_FILENAME = $(PI_GEN_DEPLOY_DIR)/$(IMG_NAME).img

$(BASE_IMG_FILENAME):
	sudo -E ./build.sh

%.sha256: %
	shasum -a 256 $< | sudo tee $@

$(phony all): $(BASE_IMG_FILENAME) $(BASE_IMG_FILENAME).sha256

$(phony clean):
	sudo rm -rf $(PI_GEN_DEPLOY_DIR)/*.img