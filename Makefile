TARGETS=ol79
DOCKER=docker

.PHONY: $(TARGETS)

all: $(TARGETS)

$(TARGETS):
	$(DOCKER) build --progress plain --tag $@ $@/
