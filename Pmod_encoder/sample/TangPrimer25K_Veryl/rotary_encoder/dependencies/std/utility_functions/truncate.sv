

`ifdef __veryl_test_rotary_encoder_test_truncate__
    `ifdef __veryl_wavedump_rotary_encoder_test_truncate__
        module __veryl_wavedump;
            initial begin
                $dumpfile("test_truncate.vcd");
                $dumpvars();
            end
        endmodule
    `endif

`endif
//# sourceMappingURL=truncate.sv.map
