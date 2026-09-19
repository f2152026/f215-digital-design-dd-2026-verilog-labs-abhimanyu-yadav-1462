

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp_result;
  integer    i, j, k;
  integer    errors, total;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    total  = 0;

    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        for (k = 0; k < 2; k = k + 1) begin
          t_a  = i;
          t_b  = j;
          t_op = k;
          #5;

          // expected result computed independently of the DUT's logic
          if (k == 0)
            exp_result = i + j;
          else
            exp_result = i - j;

          total = total + 1;
          if (t_result !== exp_result) begin
            errors = errors + 1;
            $display("FAIL at time %0t: a=%d b=%d op=%b  got %d  expected %d",
                     $time, t_a, t_b, t_op, t_result, exp_result);
          end
        end
      end
    end

    $write("SUMMARY: %0d of %0d passed", total - errors, total);
    if (errors == 0)
      $write(" -- ALL PASS");
    $write("\n");

    $finish;
  end

endmodule