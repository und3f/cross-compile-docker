TARGETS=ol79
DOCKER=docker
RM=rm

GIT_VERSION=2.9.5
GO_VERSION=1.21.5

GIT_PACKAGE=git-$(GIT_VERSION).tar.gz
GO_PACKAGE=go$(GO_VERSION).src.tar.gz

WORK_DIR=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PKG_DIR=$(WORK_DIR)/packages

GIT_PACKAGE_FULL_PATH=$(PKG_DIR)/$(GIT_PACKAGE)
GO_PACKAGE_FULL_PATH=$(PKG_DIR)/$(GO_PACKAGE)

ALL_PACKAGES=$(GIT_PACKAGE_FULL_PATH) \
						 $(GO_PACKAGE_FULL_PATH)

.PHONY: $(TARGETS) clean

all: $(TARGETS)

$(GIT_PACKAGE_FULL_PATH):
	 wget "https://mirrors.edge.kernel.org/pub/software/scm/git/$(GIT_PACKAGE)" -O $(GIT_PACKAGE_FULL_PATH)

$(GO_PACKAGE_FULL_PATH):
	 wget "https://go.dev/dl/$(GO_PACKAGE)" -O $(GO_PACKAGE_FULL_PATH)

$(TARGETS): $(ALL_PACKAGES)
	$(DOCKER) build \
		--build-arg git_version=$(GIT_VERSION) \
		--build-arg git_package=$(GIT_PACKAGE) \
		--build-arg go_version=$(GO_VERSION) \
		--build-arg go_package=$(GO_PACKAGE) \
		--progress plain \
		--tag $@ \
		-f $@/Dockerfile \
		$(PKG_DIR)

clean:
	$(RM) $(ALL_PACKAGES)
