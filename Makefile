SHELL		:= bash
.DEFAULT_GOAL	:= help

AWKSRCS		:= $(shell find . -type f -name 'run.awk')
RUNS		:= $(patsubst ./%/,%,$(dir $(AWKSRCS)))
AWK		:= awk
AWKFLAGS	:= -i rplib.awk
ifneq ($(DEBUG),)
AWKFLAGS	+= -v dbg=1
endif

# $1: awk script
define RUN_rule
.PHONY: run-$1

ifeq ($$(FILE),)
$1-input	:= $$(firstword $$(wildcard $$(dir $1)test*.txt))
else
$1-input	:= $$(FILE)
endif

run-$1: $1/run.awk $$($1-input)
	$$(AWK) $$(AWKFLAGS) -f $$< $$($1-input)
endef
$(foreach r,$(RUNS),$(eval $(call RUN_rule,$r)))

.PHONY: all help

define HELP_message
usage: make [GOAL...] [VAR=VALUE...]

GOALS:
  help                print this help message
  run-YEAR/DAY/PART   run part PART (1 or 2) of day DAY (1 to 25) of year YEAR (2015 to 2023)
  all                 runs all parts

VARIABLES:
  FILE                input file
  DEBUG               run in debug mode if set to non-empty string

endef
export HELP_message

help::
	printf '%s' "$$HELP_message"

all:
	$(info $(RUNS))
