import cocotb

@cocotb.test()
async def test_basic(dut):
    dut._log.info("DUT successfully instantiatd!");