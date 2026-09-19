// tb.v
// Self-checking testbench for comp2.

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer i, j;
  integer errors;

  reg exp_gt, exp_lt, exp_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
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

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;

        // expected values
        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);

        // compare against DUT outputs
        if (t_gt !== exp_gt || t_lt !== exp_lt || t_eq !== exp_eq) begin
          errors = errors + 1;
          $display("FAIL: A=%d B=%d | GT=%b LT=%b EQ=%b (expected GT=%b LT=%b EQ=%b)",
                   t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        end

        // exactly one output must be high
        if ((t_gt + t_lt + t_eq) !== 1) begin
          errors = errors + 1;
          $display("FAIL: A=%d B=%d | not exactly one output is 1", t_a, t_b);
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 16 combinations correct");
    else
      $display("TEST FAILED: %0d error(s)", errors);

    $finish;
  end

  initial
    $monitor($time, " A=%d B=%d | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule