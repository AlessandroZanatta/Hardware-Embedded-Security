module stream_cipher (
    input            clk,
    input            rst_n,
    input      [7:0] key,
    input      [7:0] ptxt_char,
    input  reg       din_valid,
    output     [7:0] ctxt_char,
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

  // Encryption (with checks)
  assign ctxt_char = ptxt_char ^ scb;


  // Output char (ciphertext)
  always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
      cb <= key;
      dout_valid <= 1'b0;
    end else begin
      if (din_valid) begin
        // Perform modulo operation by checking if [cb] is 255 or not.
        // If it is, the result is zero, otherwise it is [cb] + 1
        // This avoids having to implicitly take the modulo by overflowing [cb],
        // and also avoids having to declare [cb] as a 9-bit vector.
        //
        // Might or might not be the correct/best/more efficient choice.
        cb <= cb == 255 ? 0 : (cb + 8'h01);
        dout_valid <= 1'b1;
      end else begin
        dout_valid <= 1'b0;
      end
    end


endmodule
