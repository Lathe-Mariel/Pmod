


`ifdef __veryl_test_rotary_encoder_test_min_max__
    `ifdef __veryl_wavedump_rotary_encoder_test_min_max__
        module __veryl_wavedump;
            initial begin
                $dumpfile("test_min_max.vcd");
                $dumpvars();
            end
        endmodule
    `endif

`endif
//# sourceMappingURL=min_max.sv.map
