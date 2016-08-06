.PHONY: test
test: test_unit test_acceptance clean

.PHONY: test_acceptance
test_acceptance: tmp/server.pid
	crystal spec $$(find ./spec/acceptance/ -name '*_spec.cr')

.PHONY: test_unit
test_unit:
	crystal spec $$(find ./spec/unit/ -name '*_spec.cr')

tmp/server: tmp/
	crystal build ./spec/support/server.cr -o ./tmp/server

tmp/:
	mkdir -p ./tmp

tmp/server.pid: tmp/server
	./tmp/server -p 3999 > ./tmp/server.log & echo $$! >> ./tmp/server.pid

.PHONY: clean
clean: stop_server
	rm -rf ./tmp

.PHONY: stop_server
stop_server:
	[ -e ./tmp/server.pid ] && $$(ps $$(cat ./tmp/server.pid) | grep -q $$(cat ./tmp/server.pid)) && kill $$(cat ./tmp/server.pid) || true
