test: test_unit test_acceptance

test_acceptance:
	./bin/run_acceptance_tests
test_unit:
	crystal spec ./spec/unit/*
