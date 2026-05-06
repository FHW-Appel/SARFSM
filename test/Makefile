#### make rules for running cocotb
cocotb:
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile.sim \
		SIM=icarus \
		WAVES=1 \
		VERILOG_SOURCES=$(PWD)/../src/sarfsm.v \
		TOPLEVEL=sar_fsm \
		COCOTB_TEST_MODULES=sarfsm
		
