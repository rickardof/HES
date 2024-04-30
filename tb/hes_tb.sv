module AES_Stream_Cipher_tb;
'include "S_Box_Function.sv"

  reg clk = 1'b0;
  always #5 clk = !clk; // Clock period is 10 time units

  reg rst_n = 1'b0;
  initial #14.5 rst_n = 1'b1; // Reset is asserted for one clock cycle

  reg input_valid = 1'b0;
  reg new_message = 1'b0;
  reg is_ciphertext = 1'b0;
  reg [7:0] key = 8'h00; //initialization value of key
  reg [7:0] plaintext_array [0:255];
  reg [7:0] ciphertext_array [0:255];
  wire [7:0] output_array [0:255];
  wire output_valid;

  // Arrays to hold expected output values
  reg [7:0] expected_ciphertext_array [0:255];
  reg [7:0] expected_plaintext_array [0:255];

  AES_Stream_Cipher dut (
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .input_valid(input_valid),
    .new_message(new_message),
    .is_ciphertext(is_ciphertext),
    .plaintext_array(plaintext_array),
    .ciphertext_array(ciphertext_array),
    .output_valid(output_valid),
    .output_array(output_array)
  );
  
  // Stimuli routine
  initial begin
    // Load test vectors
    $readmemh("tv/plaintext_array.txt", plaintext_array);
    $readmemh("tv/ciphertext_array.txt", ciphertext_array);

    // Load expected output from files
    $readmemh("tv/expected_ciphertext_array.txt", expected_ciphertext_array);
    $readmemh("tv/expected_plaintext_array.txt", expected_plaintext_array);

    @(posedge rst_n);
    @(posedge clk);

    // Apply input data
    input_valid = 1'b1;
    new_message = 1'b1;
	
    // Apply key from the file if wanted
    //$readmemh("tv/key.txt", key);
  end

  // Check routine
  initial begin
    @(posedge rst_n);
    @(posedge clk);
	
	// Counter initialization


    // Wait for output to become valid and compare with expected output
    for (int i = 0; i < 256; i = i + 1) begin
      wait(output_valid) @ (posedge clk);
      // Compare output_array[i] with expected value
      if (is_ciphertext) begin
        // Expected ciphertext values stored in expected_ciphertext_array
        if (output_array[i] !== expected_ciphertext_array[i]) begin
          $display("ERROR: Ciphertext mismatch at index %d. Expected: %h, Actual: %h", i, expected_ciphertext_array[i], output_array[i]);
        end
      end else begin
        // Expected plaintext values stored in expected_plaintext_array
        if (output_array[i] !== expected_plaintext_array[i]) begin
          $display("ERROR: Plaintext mismatch at index %d. Expected: %h, Actual: %h", i, expected_plaintext_array[i], output_array[i]);
        end
      end
    end

    // Stop simulation
    $stop;
  end

endmodule
