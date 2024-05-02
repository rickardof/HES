module AES_Stream_Cipher_tb;

  reg clk = 1'b0;
  always #15 clk = !clk;  // Period of the clock is 15 units, so it changes every 15 units

  reg rst_n = 1'b0;
  initial #20 rst_n = 1'b1; // Reset changes just one time

  reg input_valid = 1'b0;
  reg new_message = 1'b0;
  reg [7:0] key;
  reg [7:0] input_data;
  
  wire output_valid;
  wire [7:0] output_byte;
  wire [7:0] counter_block;

  AES_Stream_Cipher UUT (
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .input_valid(input_valid),
    .new_message(new_message),
    .input_data(input_data),
    .output_valid(output_valid),
    .output_byte(output_byte),
    .counter_block(counter_block)
  );

  reg [7:0] tv_key [10];
  reg [7:0] tv_input_data [10];
  reg [7:0] tv_output_byte [10];
  reg [7:0] tv_counter_block [10];

  // ---- Stimuli routine
  initial begin
    $readmemh("tv/key.txt", tv_key);
    $readmemh("tv/input_data.txt", tv_input_data);
	$readmemh("tv/output_byte.txt", tv_output_byte);
    $readmemh("tv/counter_block.txt", tv_counter_block);
	key = tv_key[0];

    @(posedge rst_n);
    @(posedge clk);

    for (int i = 0; i < 10; i++) begin
      @ (posedge clk);
      //key = tv_key[0]; let's try giving the top level design the key as soon as possible
      input_data = tv_input_data[i];
	  if (i>=1) 
		new_message=1'b0;
	  else
		new_message=1'b1;
		
      input_valid = 1'b1;
     
	  
    end
  end



  // ---- Check routine
  initial begin
   

    @(posedge rst_n);
    @(posedge clk);

    for (int i = 0; i < 10; i++) begin
        wait(output_valid) @ (posedge clk)
        if (output_byte !== tv_output_byte[i] || counter_block !== tv_counter_block[i])
          $display("Test %2d := ERROR (expected output_byte = %02h, got = %02h, expected counter_block = %02h, got = %02h)",
                    i + 1, tv_output_byte[i], output_byte, tv_counter_block[i], counter_block);
        else
          $display("Test %2d := OK", i + 1);
      end
      $stop;
  end

endmodule
