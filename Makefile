REACTIVE_TOOLS							= gianlu33/reactive-tools
EVENT_MANAGER_SGX						= gianlu33/reactive-event-manager:sgx
EVENT_MANAGER_NATIVE					= gianlu33/reactive-event-manager:native
REACTIVE_UART2IP						= gianlu33/reactive-uart2ip

TAG 									?= latest
APP										?= utils/sancus/reactive.elf

VOLUME									?= $(shell pwd)

# arguments of reactive-tools
LOG										?= verbose
WORKSPACE								?= demo
CONFIG									?= sgx.json
RESULT									?= result.json
CONNECTION								?= trigger-btn
MODULE									?= sm1
ENTRY									?= entry

ifndef ARG
ARG_FLAG								=
else
ARG_FLAG								= --arg $(ARG)
endif

# environment variables for event_manager
EM_LOG									?= info
EM_THREADS								?= 16
EM_PERIODIC_TASKS						?= false

build:
	reactive-tools --$(LOG) build --workspace $(WORKSPACE) $(CONFIG)

deploy:
	reactive-tools --$(LOG) deploy --workspace $(WORKSPACE) $(CONFIG) --result ../$(RESULT)

call:
	reactive-tools --$(LOG) call --config $(RESULT) --module $(MODULE) --entry $(ENTRY) $(ARG_FLAG)

output:
	reactive-tools --$(LOG) output --config $(RESULT) --connection $(CONNECTION) $(ARG_FLAG)

request:
	reactive-tools --$(LOG) request --config $(RESULT) --connection $(CONNECTION) $(ARG_FLAG)

run:
	docker run --rm -it --network=host -v $(VOLUME):/usr/src/app/ -v /var/run/aesmd/:/var/run/aesmd $(REACTIVE_TOOLS):$(TAG) bash

event_manager_sgx: check_port
	docker run --rm -v /var/run/aesmd/:/var/run/aesmd/ --network=host --device=/dev/isgx -e EM_PORT=$(PORT) -e EM_LOG=$(EM_LOG) -e EM_THREADS=$(EM_THREADS) -e EM_PERIODIC_TASKS=$(EM_PERIODIC_TASKS) $(REACTIVE_TOOLS):$(TAG) event_manager

event_manager_native: check_port
	docker run --rm --network=host -e EM_PORT=$(PORT) -e EM_LOG=$(EM_LOG) -e EM_THREADS=$(EM_THREADS) -e EM_PERIODIC_TASKS=$(EM_PERIODIC_TASKS) -e EM_SGX=false $(REACTIVE_TOOLS):$(TAG) event_manager

reactive_uart2ip: check_port check_device
	docker run --rm --network=host --device=$(DEVICE) $(REACTIVE_UART2IP) reactive-uart2ip -p $(PORT) -d $(DEVICE)

clean:
	docker rm $(shell docker ps -a -q) 2> /dev/null || true
	docker image prune -f

load: check_device
	sancus-loader -device $(DEVICE) $(APP)
	screen $(DEVICE) 57600

check_port:
	@test $(PORT) || (echo "PORT variable not defined. Run make <target> PORT=<port>" && return 1)

check_device:
	@test $(DEVICE) || (echo "DEVICE variable not defined. Run make <target> DEVICE=<device>" && return 1)
