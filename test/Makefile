#### make rules for running cocotb
cocotb:
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile.sim \
		SIM=icarus \
		VERILOG_SOURCES=$(PWD)/../src/sarfsm.v \
		TOPLEVEL=sar_fsm \
		COCOTB_TEST_MODULES=sarfsm







