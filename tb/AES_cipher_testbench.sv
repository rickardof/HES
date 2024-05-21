module AES_cipher_testbench;
    //add debugs for all values, first check whether s_box function works properly
    reg clk = 1'b0;
    reg reset_n = 1'b0;
    reg new_message = 1'b0;
    reg [7:0] key;

    reg [7:0] data_in;
    reg valid_in = 1'b0;
    
    wire [7:0] data_out;
    wire valid_out;

    initial #14.5 reset_n = 1'b1; // Reset changes just one time
    always #5.5 clk = !clk; // Period of the clock is 11 units

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

// Internal signals
reg [7:0] tv_key [1];
reg [7:0] tv_input_data [256]; // Assuming max 256 bytes of data
reg [7:0] tv_expected_output [256]; // Assuming max 256 bytes of data
integer data_len;
integer file, r;

// ---- Stimuli routine
initial begin
    // reading from files (of dynamic size)
    $readmemh("tv/key.txt", tv_key);
    file = $fopen("tv/input.txt", "r");
    data_len = 0;
    while (!$feof(file)) begin
        r = $fscanf(file, "%h\n", tv_input_data[data_len]);
        data_len = data_len + 1;
    end
    $fclose(file);
    $readmemh("tv/expected_output.txt", tv_expected_output);

    // actual test code
    @(posedge reset_n);
    @(posedge clk);
    key = tv_key[0];
    new_message = 1'b1;

    for (int j = 0; j < data_len; j++) begin
        @(posedge clk);
        new_message = 1'b0;
        data_in = tv_input_data[j];
        valid_in = 1'b1;
    end
end

// ---- Check routine
initial begin
    @(posedge reset_n);
    @(posedge clk);

    for (int j = 0; j < data_len; j++) begin
        wait(valid_out);
        @(posedge clk);
        if (data_out !== tv_expected_output[j]) begin
            $display("Test %2d := ERROR (expected output_byte = %02h, got = %02h)", j+1, tv_expected_output[j], data_out);
        end else begin
            $display("Test %2d := OK", j+1);
        end
    end
    $stop;
end

endmodule