BUILD_DIR = build
TRANSITE_EXE = $(BUILD_DIR)/bin/transit_service

.PHONY: all web service transit_service clean run debug docs lint lintQ

all: transit_service

transit_service: web service

web:
    cd web; npm install; npm run build;

service:
    $(MAKE) -C service

run:
ifeq (,$(wildcard $(TRANSITE_EXE)))
    $(MAKE) -j
endif
    ./$(TRANSITE_EXE) $(PORT) web/dist

debug: transit_service
    gdb --args ./$(TRANSITE_EXE) $(PORT) web/dist

clean:
    rm -rf $(BUILD_DIR)

docs:
    cd docs; doxygen Doxyfile;

lint:
    cpplint --filter=-legal/copyright,-build/include,-build/namespaces,-runtime/explicit,-build/header_guard,-runtime/references,-runtime/threadsafe_fn $(shell find ./service/include/simulationmodel/ ./service/src/simulationmodel/ -type f -name '*.cc' -o -name '*.h')

lintQ:
    find ./service/include/simulationmodel/ ./service/src/simulationmodel/ -type f -name '*.cc' -o -name '*.h' | xargs -n 1 -P 128 cpplint --filter=-legal/copyright,-build/include,-build/namespaces,-runtime/explicit,-build/header_guard,-runtime/references,-runtime/threadsafe_fn
