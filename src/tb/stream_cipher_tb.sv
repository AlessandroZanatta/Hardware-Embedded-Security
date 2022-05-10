// -----------------------------------------------------------------------------
// ---- Testbench of Caesar's cipher module for debug and corner cases check
// -----------------------------------------------------------------------------
module stream_cipher_tb;

  reg clk = 1'b0;
  always #5 clk = !clk;

  reg rst_n = 1'b0;
  event reset_deassertion; // event(s), when asserted, can be used as time trigger(s) to synchronize with: e.g. refer to lines and 14 and 81

  initial begin
    #12.8 rst_n = 1'b1;
    ->reset_deassertion;  // trigger event named 'reset_deassertion'
  end

  reg [7:0] key = 8'h00;
  reg [7:0] ptxt_char;
  wire [7:0] ctxt_char;
  reg din_valid;
  reg dout_valid;

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


  stream_cipher stream_cipher_instance (
      .clk       (clk),
      .rst_n     (rst_n),
      .key       (key),
      .ptxt_char (ptxt_char),
      .ctxt_char (ctxt_char),
      .din_valid (din_valid),
      .dout_valid(dout_valid)
  );

  reg [7:0] EXPECTED_GEN;
  reg [7:0] EXPECTED_CHECK;
  reg [7:0] EXPECTED_QUEUE [$];

  // Routine to get the correct encrypted (or decrypted) output, given the
  // current key and "offset" of the char to encyrpt (or decrypt)
  task expected_out(input byte i, output [7:0] exp_char);
    exp_char = ptxt_char ^ sbox[(key+i)%256];
  endtask

  initial begin
    // ------------------------------------------------------------------
    @(reset_deassertion);  // Hook reset deassertion (event)
    // ------------------------------------------------------------------
    // Alternative: 
    // do not create event reset_deassertion, keep rst_n with same behaviour, and here replace with...
    // @(posedge rst_n);
    // ------------------------------------------------------------------

    @(posedge clk);  // Hook next rising edge of signal clk (used as clock)

    fork  // -------------------------------------------------------------------

      begin : STIMULI_1R
        for (byte i = 0; i < 256; i++) begin
          ptxt_char = i;
          din_valid = 1'b1;
          @(posedge clk);
          expected_out(i, EXPECTED_GEN);
          EXPECTED_QUEUE.push_back(EXPECTED_GEN);
          din_valid = 1'b0;
        end
      end : STIMULI_1R

      begin : CHECK_1R
        @(posedge clk);
        for (int j = 0; j < 256; j++) begin
          @(posedge clk);

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
      end : CHECK_1R

    join
    $stop;
  end
endmodule


//     join  // closing fork at line 92 -------------------------------------------

//     // -------------------------------------------------------------------------
//     /*  SystemVerilog offers the fork-join statement that works like in C language
//         Use cases:
//           1.  fork
//                 <...>
//                 <...>
//               join
//           // -- wait for all actions within fork - join are completed: the simulation hangs within this block until all actions are completed.
//                 Pay attention to the kind of actions specified and their duration.

//           2.  fork
//                 <...>
//                 <...>
//               join_none
//           // -- no wait of actions within fork - join_none: all actions are launched without waiting for their completion, hence the simulation continues
//                 with the next statement after the join_none keyword, independently if actions within fork - join_none are completed or not. In this case
//                 it can be very useful to name the actions (or blocks, delimited by a begin - end couple) with a label, in order to eventually disable them
//                 with the statement disable, e.g.: refer to begin - end block starting at line 126, whose name is STIMULI_1R, it could be disable by using
//                 the statement 'disable STIMULI_1R;'.
//                 The usage of fork - join_none is useful in case some tasks or actions need to be run and executed in background while continuing with the
//                 simulation.

//           3.  fork
//                 <...>
//                 <...>
//               join_any
//           // -- wait only the first action within fork - join_any is completed: all actions are launched and just the first one which is completed makes the
//                 simulation exit from the fork - join_any block and continues with the statements after the join_any keyword; all other actions of fork - join_any
//                 block that are not concluded are still executed in background. Also in this case, the usage of labels for actions/blocks (begin - end) inside
//                 the fork - join_any block allows to disable them later, if required.
//     */
//     // -------------------------------------------------------------------------

//     @(posedge clk);
//     shift_dir = 1'b1; // Set shift direction to left; note: number of positions to be shifted is unmodified, hence it is still 1, as set at line 90

//     fork  // -------------------------------------------------------------------

//       begin : STIMULI_1L
//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "A" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end

//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "a" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end
//       end : STIMULI_1L

//       begin : CHECK_1L
//         @(posedge clk);
//         for (int j = 0; j < 52; j++) begin
//           @(posedge clk);
//           EXPECTED_CHECK = EXPECTED_QUEUE.pop_front();
//           $display("%c %c %-5s", ctxt_char, EXPECTED_CHECK,
//                    EXPECTED_CHECK === ctxt_char ? "OK" : "ERROR");
//           if (EXPECTED_CHECK !== ctxt_char) $stop;
//         end
//       end : CHECK_1L

//     join  // closing fork at line 158 ------------------------------------------

//     @(posedge clk);
//     shift_dir = 1'b0;  // Set shift direction to right
//     shift_N   = 5'd5;  // Set number of positions to be shifted to 5

//     fork  // -------------------------------------------------------------------

//       begin : STIMULI_5R
//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "A" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end

//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "a" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end
//       end : STIMULI_5R

//       begin : CHECK_5R
//         @(posedge clk);
//         for (int j = 0; j < 52; j++) begin
//           @(posedge clk);
//           EXPECTED_CHECK = EXPECTED_QUEUE.pop_front();
//           $display("%c %c %-5s", ctxt_char, EXPECTED_CHECK,
//                    EXPECTED_CHECK === ctxt_char ? "OK" : "ERROR");
//           if (EXPECTED_CHECK !== ctxt_char) $stop;
//         end
//       end : CHECK_5R

//     join  // closing fork at line 192 ------------------------------------------

//     @(posedge clk);
//     shift_dir = 1'b1;

//     fork  // -------------------------------------------------------------------

//       begin : STIMULI_5L
//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "A" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end

//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "a" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end
//       end : STIMULI_5L

//       begin : CHECK_5L
//         @(posedge clk);
//         for (int j = 0; j < 52; j++) begin
//           @(posedge clk);
//           EXPECTED_CHECK = EXPECTED_QUEUE.pop_front();
//           $display("%c %c %-5s", ctxt_char, EXPECTED_CHECK,
//                    EXPECTED_CHECK === ctxt_char ? "OK" : "ERROR");
//           if (EXPECTED_CHECK !== ctxt_char) $stop;
//         end
//       end : CHECK_5L

//     join  // closing fork at line 225 ------------------------------------------

//     @(posedge clk);
//     shift_dir = 1'b0;  // Set shift direction to right
//     shift_N   = 5'd5;  // Set number of positions to be shifted to 5

//     fork  // -------------------------------------------------------------------

//       begin : STIMULI_1R_FULL_SWEEP
//         for (int i = 0; i < 128; i++) begin
//           ptxt_char = 8'h00 + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end
//       end : STIMULI_1R_FULL_SWEEP

//       begin : CHECK_1R_FULL_SWEEP
//         @(posedge clk);
//         for (int j = 0; j < 128; j++) begin
//           @(posedge clk);
//           EXPECTED_CHECK = EXPECTED_QUEUE.pop_front();
//           $display("%c %c %-5s", ctxt_char, EXPECTED_CHECK,
//                    EXPECTED_CHECK === ctxt_char ? "OK" : "ERROR");
//           if (EXPECTED_CHECK !== ctxt_char) $stop;
//         end
//       end : CHECK_1R_FULL_SWEEP

//     join  // closing fork at line 259 ------------------------------------------

//     @(posedge clk);
//     shift_dir = 1'b0;  // Set shift direction to right
//     shift_N   = 5'd27;  // Set number of positions to be shifted to 27

//     fork  // -------------------------------------------------------------------

//       begin : STIMULI_1R_INVALID_SHIFT_N
//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "A" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end

//         for (int i = 0; i < 26; i++) begin
//           ptxt_char = "a" + i;
//           @(posedge clk);
//           expected_calc(EXPECTED_GEN);
//           EXPECTED_QUEUE.push_back(EXPECTED_GEN);
//         end
//       end : STIMULI_1R_INVALID_SHIFT_N

//       begin : CHECK_1R_INVALID_SHIFT_N
//         @(posedge clk);
//         for (int j = 0; j < 52; j++) begin
//           @(posedge clk);
//           EXPECTED_CHECK = EXPECTED_QUEUE.pop_front();
//           $display("%c %c %-5s", ctxt_char, EXPECTED_CHECK,
//                    EXPECTED_CHECK === ctxt_char ? "OK" : "ERROR");
//           if (EXPECTED_CHECK !== ctxt_char) $stop;
//         end
//       end : CHECK_1R_INVALID_SHIFT_N

//     join  // closing fork at line 286 ------------------------------------------

//     $stop;

//   end

// endmodule
// /* ################################################################################################################################################################## */

// // -----------------------------------------------------------------------------
// // ---- Testbench for file encryption
// // -----------------------------------------------------------------------------
// module caesar_ciph_tb_file_enc;

//   reg clk = 1'b0;
//   always #5 clk = !clk;

//   reg rst_n = 1'b0;
//   initial #12.8 rst_n = 1'b1;

//   reg        shift_dir;
//   reg  [4:0] shift_N;
//   reg  [7:0] ptxt_char;
//   wire [7:0] ctxt_char;

//   caesar_cipher INSTANCE_NAME (
//       .clk                      (clk),
//       .rst_n                    (rst_n),
//       .key_shift_dir            (shift_dir),
//       .key_shift_num            (shift_N),
//       .ptxt_char                (ptxt_char),
//       .ctxt_char                (ctxt_char),
//       .err_invalid_key_shift_num(  /* Unconnected */),
//       .err_invalid_ptxt_char    (  /* Unconnected */)
//   );

//   localparam UPPERCASE_A_CHAR = 8'h41;
//   localparam UPPERCASE_Z_CHAR = 8'h5A;
//   localparam LOWERCASE_A_CHAR = 8'h61;
//   localparam LOWERCASE_Z_CHAR = 8'h7A;

//   int FP_PTXT;
//   int FP_CTXT;
//   string char;
//   reg [7:0] CTXT[$];
//   reg [7:0] PTXT[$];

//   initial begin
//     @(posedge rst_n);

//     @(posedge clk);
//     FP_PTXT = $fopen("tv/ptxt.txt", "r");
//     $write("Encrypting file 'tv/ptxt.txt' to 'tv/ctxt.txt'... ");
//     shift_dir = 1'b0;
//     shift_N   = 5'd2;

//     while ($fscanf(
//         FP_PTXT, "%c", char
//     ) == 1) begin
//       ptxt_char = int'(char);
//       @(posedge clk);
//       if(
//         ((ptxt_char >= UPPERCASE_A_CHAR ) && (ptxt_char <= UPPERCASE_Z_CHAR)) ||
//         ((ptxt_char >= LOWERCASE_A_CHAR ) && (ptxt_char <= LOWERCASE_Z_CHAR))
//       ) begin
//         @(posedge clk);
//         CTXT.push_back(ctxt_char);
//       end else CTXT.push_back(ptxt_char);
//     end
//     $fclose(FP_PTXT);

//     FP_CTXT = $fopen("tv/ctxt.txt", "w");
//     foreach (CTXT[i]) $fwrite(FP_CTXT, "%c", CTXT[i]);
//     $fclose(FP_CTXT);

//     $display("Done!");

//     @(posedge clk);
//     FP_CTXT = $fopen("tv/ctxt.txt", "r");
//     $write("Decrypting file 'tv/ctxt.txt' to 'tv/dec.txt'... ");
//     shift_dir = 1'b1;
//     shift_N   = 5'd2;

//     while ($fscanf(
//         FP_CTXT, "%c", char
//     ) == 1) begin
//       ptxt_char = int'(char);
//       @(posedge clk);
//       if(
//         ((ptxt_char >= UPPERCASE_A_CHAR ) && (ptxt_char <= UPPERCASE_Z_CHAR)) ||
//         ((ptxt_char >= LOWERCASE_A_CHAR ) && (ptxt_char <= LOWERCASE_Z_CHAR))
//       ) begin
//         @(posedge clk);
//         PTXT.push_back(ctxt_char);
//       end else PTXT.push_back(ptxt_char);
//     end
//     $fclose(FP_CTXT);

//     FP_PTXT = $fopen("tv/dec.txt", "w");
//     foreach (PTXT[i]) $fwrite(FP_PTXT, "%c", PTXT[i]);
//     $fclose(FP_PTXT);

//     $display("Done!");

//     $stop;
//   end

// endmodule
// // -----------------------------------------------------------------------------
