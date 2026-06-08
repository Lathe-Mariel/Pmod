# ============================================================================
# Timing Constraints for Efinix Trion T8F81 (AE-T8F81-DIP40)
# Clock Input: 25MHz (Period = 40.0 ns)
# ============================================================================

create_clock -period 40.00 -name clk [get_ports {clk}]
