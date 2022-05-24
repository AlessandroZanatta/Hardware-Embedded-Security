module stream_cipher_tb;

  // Clock definition (period: 10 time units)
  reg clk = 1'b0;
  always #5 clk = !clk;

  // Reset definition (negative edge triggered)
  reg rst_n = 1'b1;

  reg key_in;
  reg [7:0] key;
  reg [7:0] ptxt_char;
  wire [7:0] ctxt_char;
  reg din_valid;
  wire dout_valid;

  // Instance of our stream cipher
  stream_cipher stream_cipher_instance (
      .clk       (clk),
      .rst_n     (rst_n),
      .key_in    (key_in),
      .key       (key),
      .ptxt_char (ptxt_char),
      .ctxt_char (ctxt_char),
      .din_valid (din_valid),
      .dout_valid(dout_valid)
  );

  localparam byte sbox[0:255] = {
    8'h63,
    8'h7c,
    8'h77,
    8'h7b,
    8'hf2,
    8'h6b,
    8'h6f,
    8'hc5,
    8'h30,
    8'h01,
    8'h67,
    8'h2b,
    8'hfe,
    8'hd7,
    8'hab,
    8'h76,
    8'hca,
    8'h82,
    8'hc9,
    8'h7d,
    8'hfa,
    8'h59,
    8'h47,
    8'hf0,
    8'had,
    8'hd4,
    8'ha2,
    8'haf,
    8'h9c,
    8'ha4,
    8'h72,
    8'hc0,
    8'hb7,
    8'hfd,
    8'h93,
    8'h26,
    8'h36,
    8'h3f,
    8'hf7,
    8'hcc,
    8'h34,
    8'ha5,
    8'he5,
    8'hf1,
    8'h71,
    8'hd8,
    8'h31,
    8'h15,
    8'h04,
    8'hc7,
    8'h23,
    8'hc3,
    8'h18,
    8'h96,
    8'h05,
    8'h9a,
    8'h07,
    8'h12,
    8'h80,
    8'he2,
    8'heb,
    8'h27,
    8'hb2,
    8'h75,
    8'h09,
    8'h83,
    8'h2c,
    8'h1a,
    8'h1b,
    8'h6e,
    8'h5a,
    8'ha0,
    8'h52,
    8'h3b,
    8'hd6,
    8'hb3,
    8'h29,
    8'he3,
    8'h2f,
    8'h84,
    8'h53,
    8'hd1,
    8'h00,
    8'hed,
    8'h20,
    8'hfc,
    8'hb1,
    8'h5b,
    8'h6a,
    8'hcb,
    8'hbe,
    8'h39,
    8'h4a,
    8'h4c,
    8'h58,
    8'hcf,
    8'hd0,
    8'hef,
    8'haa,
    8'hfb,
    8'h43,
    8'h4d,
    8'h33,
    8'h85,
    8'h45,
    8'hf9,
    8'h02,
    8'h7f,
    8'h50,
    8'h3c,
    8'h9f,
    8'ha8,
    8'h51,
    8'ha3,
    8'h40,
    8'h8f,
    8'h92,
    8'h9d,
    8'h38,
    8'hf5,
    8'hbc,
    8'hb6,
    8'hda,
    8'h21,
    8'h10,
    8'hff,
    8'hf3,
    8'hd2,
    8'hcd,
    8'h0c,
    8'h13,
    8'hec,
    8'h5f,
    8'h97,
    8'h44,
    8'h17,
    8'hc4,
    8'ha7,
    8'h7e,
    8'h3d,
    8'h64,
    8'h5d,
    8'h19,
    8'h73,
    8'h60,
    8'h81,
    8'h4f,
    8'hdc,
    8'h22,
    8'h2a,
    8'h90,
    8'h88,
    8'h46,
    8'hee,
    8'hb8,
    8'h14,
    8'hde,
    8'h5e,
    8'h0b,
    8'hdb,
    8'he0,
    8'h32,
    8'h3a,
    8'h0a,
    8'h49,
    8'h06,
    8'h24,
    8'h5c,
    8'hc2,
    8'hd3,
    8'hac,
    8'h62,
    8'h91,
    8'h95,
    8'he4,
    8'h79,
    8'he7,
    8'hc8,
    8'h37,
    8'h6d,
    8'h8d,
    8'hd5,
    8'h4e,
    8'ha9,
    8'h6c,
    8'h56,
    8'hf4,
    8'hea,
    8'h65,
    8'h7a,
    8'hae,
    8'h08,
    8'hba,
    8'h78,
    8'h25,
    8'h2e,
    8'h1c,
    8'ha6,
    8'hb4,
    8'hc6,
    8'he8,
    8'hdd,
    8'h74,
    8'h1f,
    8'h4b,
    8'hbd,
    8'h8b,
    8'h8a,
    8'h70,
    8'h3e,
    8'hb5,
    8'h66,
    8'h48,
    8'h03,
    8'hf6,
    8'h0e,
    8'h61,
    8'h35,
    8'h57,
    8'hb9,
    8'h86,
    8'hc1,
    8'h1d,
    8'h9e,
    8'he1,
    8'hf8,
    8'h98,
    8'h11,
    8'h69,
    8'hd9,
    8'h8e,
    8'h94,
    8'h9b,
    8'h1e,
    8'h87,
    8'he9,
    8'hce,
    8'h55,
    8'h28,
    8'hdf,
    8'h8c,
    8'ha1,
    8'h89,
    8'h0d,
    8'hbf,
    8'he6,
    8'h42,
    8'h68,
    8'h41,
    8'h99,
    8'h2d,
    8'h0f,
    8'hb0,
    8'h54,
    8'hbb,
    8'h16
  };

  // Routine to get the correct encrypted (or decrypted) output, given the
  // current key and "offset" of the char to encyrpt (or decrypt)
  task expected_out(input byte i, output [7:0] exp_char);
    exp_char = ptxt_char ^ sbox[(key+i)%256];
  endtask

  // The key is sampled when the circuit is reset, therefore we:
  // - set the key
  // - trigger a reset
  task set_key(input byte k);
    key = k;
    key_in = 1'b1;
    @(posedge clk);
    key_in = 1'b0;
  endtask

  initial begin

    fork
      reg [7:0] EXPECTED_GEN;
      reg [7:0] EXPECTED_CHECK;
      reg [7:0] EXPECTED_QUEUE [$];

      // Try encrypting every possible character with every possible key
      // This is doable, as the space is pretty small (256 characters * 256
      // keys)
      begin
        // Set the initial key
        set_key(8'h00);

        // Loop 256*256 times to test all chars with all keys to achieve
        // 100% coverage of the encryption/decryption.
        for (int b = 0; b < 256 * 256; b++) begin

          // Set inputs and wait for their sampling by the next posedge of clk
          ptxt_char = byte'(b);
          din_valid = 1'b1;
          @(posedge clk);

          // Save expected result into the vector
          expected_out(byte'(b), EXPECTED_GEN);
          EXPECTED_QUEUE.push_back(EXPECTED_GEN);
        end
        din_valid = 1'b0;
      end

      begin
        // Wait a cycle (outputs are available at the start of the next cycle)
        @(posedge clk);
        @(posedge clk);

        // Loop to check actual outputs
        for (int j = 0; j < 256 * 256; j++) begin
          // Wait for outputs to be available
          @(posedge clk);

          // If dout_valid is asserted, check if the output is equal to the
          // expected one
          if (dout_valid == 1'b1) begin
            EXPECTED_CHECK = EXPECTED_QUEUE.pop_front();
            $display("%d: Got '%c', expected: '%c' (%-5s)", j, ctxt_char, EXPECTED_CHECK,
                     EXPECTED_CHECK === ctxt_char ? "OK" : "ERROR");
            if (EXPECTED_CHECK !== ctxt_char) $stop;
          end else begin
            $display("dout_valid not asserted. ERROR");
            $stop;
          end
        end
      end

    join
    fork
      begin
        string char, p, d;
        int PLAINTEXT_FP;
        int DEC_PLAINTEXT_FP;
        int CIPHERTEXT_FP;
        byte CIPHERTEXT[$];
        byte PLAINTEXT[$];

        localparam my_key = 8'h41;

        // -------------- //
        // Encrypt a file //
        // -------------- //
        PLAINTEXT_FP = $fopen("tv/plaintext.txt", "r");
        $write("Encrypting file `tv/plaintext.txt`... ");

        // Set the encryption key
        set_key(my_key);
        while ($fscanf(
            PLAINTEXT_FP, "%c", char
        ) == 1) begin

          // Set the ptxt_char and assert din_valid
          ptxt_char = byte'(char);
          din_valid = 1'b1;
          @(posedge clk);  // Wait for inputs sampling 

          // Here we are wasting a clock cycle in which we could encrypt
          // a char, therefore we de-assert din_valid
          din_valid = 1'b0;
          @(posedge clk);  // Wait for output to be available

          // Check that the output is indeed available and push it into the
          // ciphertext vector
          if (dout_valid == 1'b1) begin
            CIPHERTEXT.push_back(ctxt_char);
          end else begin
            $display("dout_valid not asserted. ERROR");
            $stop;
          end
        end
        $fclose(PLAINTEXT_FP);

        // Write ciphertext to file
        CIPHERTEXT_FP = $fopen("tv/ciphertext.txt", "w");
        foreach (CIPHERTEXT[i]) $fwrite(CIPHERTEXT_FP, "%c", CIPHERTEXT[i]);
        $fclose(CIPHERTEXT_FP);
        $write("Encrypted!\n");

        // ---------------- //
        // Decrypt the file //
        // ---------------- //
        CIPHERTEXT_FP = $fopen("tv/ciphertext.txt", "r");
        $write("Decrypting file `tv/ciphertext.txt`... ");

        // Set decryption key
        set_key(my_key);
        while ($fscanf(
            CIPHERTEXT_FP, "%c", char
        ) == 1) begin
          ptxt_char = byte'(char);
          din_valid = 1'b1;
          @(posedge clk);
          din_valid = 1'b0;
          @(posedge clk);
          if (dout_valid == 1'b1) begin
            PLAINTEXT.push_back(ctxt_char);
          end else begin
            $display("dout_valid not asserted. ERROR");
            $stop;
          end
        end
        $fclose(CIPHERTEXT_FP);

        // Write plaintext to file
        PLAINTEXT_FP = $fopen("tv/decrypted_plaintext.txt", "w");
        foreach (PLAINTEXT[i]) $fwrite(PLAINTEXT_FP, "%c", PLAINTEXT[i]);
        $fclose(PLAINTEXT_FP);
        $write("Decrypted!\n");

        // ----------------------------------------------------------- //
        // Check that the plaintext and the decrypted ciphertext match //
        // ----------------------------------------------------------- //
        $write("Checking result... ");

        // Open files and check that each char matches
        PLAINTEXT_FP = $fopen("tv/plaintext.txt", "r");
        DEC_PLAINTEXT_FP = $fopen("tv/decrypted_plaintext.txt", "r");

        while (!$feof(
            PLAINTEXT_FP
        ) && !$feof(
            DEC_PLAINTEXT_FP
        )) begin

          // As both files passed the feof check, they will return always
          // return a single char
          void'($fscanf(PLAINTEXT_FP, "%c", p));
          void'($fscanf(DEC_PLAINTEXT_FP, "%c", d));

          // If any char is mismatched, we failed
          if (p != d) begin
            $write("FAILED! RESULT MISMATCH!");
            $stop;
          end
        end

        $fclose(PLAINTEXT_FP);
        $fclose(DEC_PLAINTEXT_FP);
        $write("OK! D(E(x, k), k) = x!\n");
      end
    join
    $stop;

  end
endmodule
