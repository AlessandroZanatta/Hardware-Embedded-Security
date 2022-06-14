module stream_cipher (
    input            clk,
    input            rst_n,
    input      [7:0] key,
    input      [7:0] din,
    input  reg       key_in,
    input  reg       din_valid,
    output reg [7:0] dout,
    output reg       dout_valid
);

  // ---------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------

  // Counter block
  reg  [7:0] cb;

  // S-box lookup of the counter block
  wire [7:0] scb;

  // sbox module instantiation
  sbox sbox (
      .in (cb),
      .out(scb)
  );


  // ---------------------------------------------------------------------------
  // Logic Design
  // ---------------------------------------------------------------------------

  // Output char (ciphertext)
  always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
      dout_valid <= 1'b0;
      cb <= 8'h00;
    end else begin
      if (key_in) begin
        cb <= key;
      end else if (din_valid) begin
        // Perform modulo operation by checking if [cb] is 255 or not.
        // If it is, the result is zero, otherwise it is [cb] + 1
        // This avoids having to implicitly take the modulo by overflowing [cb],
        // and also avoids having to declare [cb] as a 9-bit vector.
        //
        // Might or might not be the correct/best/more efficient choice.
        cb <= cb == 8'hff ? 8'h00 : (cb + 8'h01);

        // Assert dout_valid to inform a new character has been encrypted
        dout_valid <= 1'b1;
        // Set the encrypted character
        dout <= din ^ scb;
      end else begin
        dout_valid <= 1'b0;
      end
    end
endmodule
