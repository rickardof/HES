module AES_Stream_Cipher_tb;

  // Define module inputs and outputs
  reg clk = 1'b0;
  always #5 clk = !clk; // Clock period of 10 units
  
  reg rst_n = 1'b0;
  initial #14 rst_n = 1'b1; // Reset changes just one time 

  reg in_valid = 1'b0;
  reg [7:0] key;
  reg [7:0] input_data;
  reg new_message = 1'b1;
  wire output_valid;
  wire [7:0] output_byte;
  reg [7:0] counter_block;

  // Instantiate AES_Stream_Cipher module
  AES_Stream_Cipher U0 (
     .clk(clk),
     .rst_n(rst_n),
     .key(key),
     .input_valid(in_valid),
     .new_message(new_message),
     .input_data(input_data),
     .output_valid(output_valid),
     .output_byte(output_byte),
	 .counter_block(counter_block)
  );
  
  // Define test vectors
  reg [7:0] tv_key [10];
  reg [7:0] tv_input_data [10];
  reg [7:0] tv_output_byte [10];
  
  // ---- Stimuli routine
  initial begin
    
    // Load test vectors from files
    $readmemh("tv/key.txt", tv_key);
    $readmemh("tv/input_data.txt", tv_input_data);
    
    // Wait for reset and clock edge
    @(posedge rst_n);
    @(posedge clk);
    
    // Loop through test vectors
    for(int i = 0; i < 10; i++) begin
	  @(posedge clk);
	  if(i >= 1)
		new_message = 1'b0;
	  else
		new_message = 1'b1;	
      // Apply stimulus
      key = tv_key[0];
      input_data = tv_input_data[i];
      in_valid = 1'b1;
      $display($time, " Stimulus: key=%h, input_data=%h, in_valid=%b, new_message=%b, counter_block=%h ", key, input_data, in_valid, new_message, counter_block);
	  
    end 
   end
   
   //check routine
   initial begin
	  $readmemh("tv/output_byte.txt", tv_output_byte);
      @(posedge clk);
	  @(posedge rst_n);
      
      for (int i=0; i<10; i++) begin
      wait(output_valid) @ (posedge clk);
      // Compare output with expected output
      if(output_byte !== tv_output_byte[i])
        $display ($time, " Check: Test %2d := ERROR (expected = %02h, got = %02h), input is=%h", i + 1, tv_output_byte[i], output_byte,input_data);
      else
        $display ($time, " Check: Test %2d := OK", i + 1);     
	  end 
	  new_message=1'b1;
	  $stop;
    end
endmodule


