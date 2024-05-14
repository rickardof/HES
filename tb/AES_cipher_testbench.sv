module AES_cipher_testbench;
//add debugs for all values, first check whether s_box function works properly
  reg clk = 1'b0;
  always #5.5 clk = !clk;  // Period of the clock is 11 units

  reg reset_n = 1'b0;
  initial #14.5 reset_n = 1'b1; // Reset changes just one time

  reg valid_in = 1'b0;
  reg new_message = 1'b0;
  reg [7:0] key;
  reg [7:0] data_in;
  
  wire valid_out;
  wire [7:0] data_out;

  
  

  AES_cipher UUT (
    .clk(clk),
    .reset_n(reset_n),
	.valid_in(valid_in),
	.new_message(new_message),
    .key(key),
    .data_in(data_in),
	.data_out(data_out),
    .valid_out(valid_out)
  );
//internal signals
  reg [7:0] tv_key [10];
  reg [7:0] tv_input_data [10];
  reg [7:0] tv_output_byte [10];
  reg [7:0] tv_counter_block [10];

  // ---- Stimuli routine
initial begin
    //$readmemh("tv/key.txt", tv_key);
    $readmemh("tv/input_data.txt", tv_input_data);
	$readmemh("tv/output_byte.txt", tv_output_byte);
    

      // Assuming the key is static for this test.
    @(posedge reset_n);
    @(posedge clk);
	key = 8'h11;
	new_message =1'b1;

    for (int j = 0; j < 10; j++) begin
      @(posedge clk);
      new_message = 1'b0;  //
	  data_in = tv_input_data[j];
	 
      valid_in = 1'b1; 
    end
    
    
end




  // ---- Check routine
  initial begin
   

    @(posedge reset_n);
    @(posedge clk);

    for (int j = 0; j < 10; j++) begin
      wait(valid_out);
	  @ (posedge clk);
      if (data_out !== tv_output_byte[j]) begin
        $display("Test %2d := ERROR (expected output_byte = %02h, got = %02h)",
                  j + 1, tv_output_byte[j],data_out);
      end else begin
        $display("Test %2d := OK", j + 1);
      end
    end
	 $stop;  
  end
endmodule