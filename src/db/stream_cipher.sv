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

      // Per specifications, dout is not valid unless dout_valid is asserted
      // As resetting this would cause a loss in performance, we decided to
      // not set this reg on reset.
      // dout <= 8'h00;
    end else begin
      if (key_in) begin
        cb <= key;
        dout_valid <= 1'b0;
      end else if (din_valid) begin
        // Perform modulo operation by adding one.
        // When cb is 255, the modulo is taken implicitly by overflow.
        // This results in a performance improvement (without generating any
        // warning).
        cb <= cb + 8'h01;

        // Assert dout_valid to inform a new character has been encrypted
        dout_valid <= 1'b1;
        // Set the encrypted character
        dout <= din ^ scb;
      end else begin
        dout_valid <= 1'b0;
      end
    end
endmodule
