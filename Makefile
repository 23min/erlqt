ERL					?= erl
ERLC				= erlc
EBIN_DIRS		    := $(wildcard deps/*/ebin)
APPS				:= $(shell ls apps)
REL_DIR             = rel
NODE				= loggr
REL					= loggr
SCRIPT_PATH         := $(REL_DIR)/$(NODE)/bin/$(REL)

.PHONY: rel deps

all: deps compile sync

compile: deps
	@rebar compile

deps:
	@rebar get-deps
	@rebar check-deps

clean:
	@rebar clean
	#-rm -rvf deps ebin doc .eunit

realclean: clean
	@rebar delete-deps

test:
	@rebar skip_deps=true ct

rel: deps
	@rebar compile generate

start: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) start

stop: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) stop

ping: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) ping

attach: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) attach

console: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) console

restart: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) restart

reboot: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) reboot

doc:
	rebar skip_deps=true doc
	for app in $(APPS); do \
		cp -R apps/$${app}/doc doc/$${app}; \
	done;

sync:
	cd deps/sync && make && cd -

run:
	erl -pa apps/*/ebin apps/*/include deps/*/ebin deps/*/include -args_file start.args

dev:
	erl -make #uses Emakefile and adds debug_info
	@erl -pa apps/*/ebin apps/*/include deps/*/ebin deps/*/include ebin include -boot start_sasl  -s app1 -s sync

analyze: checkplt
	@rebar skip_deps=true dialyze

buildplt:
	@rebar skip_deps=true build-plt

checkplt: buildplt
	@rebar skip_deps=true check-plt
