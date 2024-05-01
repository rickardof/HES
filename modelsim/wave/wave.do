onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/clk
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/rst_n
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/input_valid
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/new_message
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/key
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/input_data
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/output_valid
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/output_byte
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/counter_block
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/tv_key
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/tv_input_data
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/tv_output_byte
add wave -noupdate -radix hexadecimal /AES_Stream_Cipher_tb/tv_counter_block
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {610 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {595 ps}
