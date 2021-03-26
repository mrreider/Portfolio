//Reid Brostoff

module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;
   // Row outputs
   wire [15:0] rotL_r1, rotL_r2, rotL_r3, rotL_r4,          // mux outputs for rotating left
               shftL_r1, shftL_r2, shftL_r3, shftL_r4,      // mux outputs for shifting left 
               shftRA_r1, shftRA_r2, shftRA_r3, shftRA_r4,  // mux outputs for Arith shift right
               shftRL_r1, shftRL_r2, shftRL_r3, shftRL_r4;  // mux outputs for logical shift right
   
   // intermediate wires
   
   // Rotate left implementation. need 4 rows of muxes
   // column 1
   assign rotL_r1[0] = Cnt[0] ? In[15] : In[0]; // row 0
   assign rotL_r1[1] = Cnt[0] ? In[0] : In[1]; // row 1
   assign rotL_r1[2] = Cnt[0] ? In[1] : In[2]; // row 2
   assign rotL_r1[3] = Cnt[0] ? In[2] : In[3]; // row 3
   assign rotL_r1[4] = Cnt[0] ? In[3] : In[4]; // row 4
   assign rotL_r1[5] = Cnt[0] ? In[4] : In[5]; // row 5
   assign rotL_r1[6] = Cnt[0] ? In[5] : In[6]; // row 6
   assign rotL_r1[7] = Cnt[0] ? In[6] : In[7]; // row 7
   assign rotL_r1[8] = Cnt[0] ? In[7] : In[8]; // row 8
   assign rotL_r1[9] = Cnt[0] ? In[8] : In[9]; // row 9
   assign rotL_r1[10] = Cnt[0] ? In[9] : In[10]; // row 10
   assign rotL_r1[11] = Cnt[0] ? In[10] : In[11]; // row 11
   assign rotL_r1[12] = Cnt[0] ? In[11] : In[12]; // row 12
   assign rotL_r1[13] = Cnt[0] ? In[12] : In[13]; // row 13
   assign rotL_r1[14] = Cnt[0] ? In[13] : In[14]; // row 14
   assign rotL_r1[15] = Cnt[0] ? In[14] : In[15]; // row 15

   //column 2
   assign rotL_r2[0] = Cnt[1] ? rotL_r1[14] : rotL_r1[0]; // row 0
   assign rotL_r2[1] = Cnt[1] ? rotL_r1[15] : rotL_r1[1]; // row 1
   assign rotL_r2[2] = Cnt[1] ? rotL_r1[0] : rotL_r1[2]; // row 2
   assign rotL_r2[3] = Cnt[1] ? rotL_r1[1] : rotL_r1[3]; // row 3
   assign rotL_r2[4] = Cnt[1] ? rotL_r1[2] : rotL_r1[4]; // row 4
   assign rotL_r2[5] = Cnt[1] ? rotL_r1[3] : rotL_r1[5]; // row 5
   assign rotL_r2[6] = Cnt[1] ? rotL_r1[4] : rotL_r1[6]; // row 6
   assign rotL_r2[7] = Cnt[1] ? rotL_r1[5] : rotL_r1[7]; // row 7
   assign rotL_r2[8] = Cnt[1] ? rotL_r1[6] : rotL_r1[8]; // row 8
   assign rotL_r2[9] = Cnt[1] ? rotL_r1[7] : rotL_r1[9]; // row 9
   assign rotL_r2[10] = Cnt[1] ? rotL_r1[8] : rotL_r1[10]; // row 10
   assign rotL_r2[11] = Cnt[1] ? rotL_r1[9] : rotL_r1[11]; // row 11
   assign rotL_r2[12] = Cnt[1] ? rotL_r1[10] : rotL_r1[12]; // row 12
   assign rotL_r2[13] = Cnt[1] ? rotL_r1[11] : rotL_r1[13]; // row 13
   assign rotL_r2[14] = Cnt[1] ? rotL_r1[12] : rotL_r1[14]; // row 14
   assign rotL_r2[15] = Cnt[1] ? rotL_r1[13] : rotL_r1[15]; // row 15

   //column 3
   assign rotL_r3[0] = Cnt[2] ? rotL_r2[12] : rotL_r2[0]; // row 0
   assign rotL_r3[1] = Cnt[2] ? rotL_r2[13] : rotL_r2[1]; // row 1
   assign rotL_r3[2] = Cnt[2] ? rotL_r2[14] : rotL_r2[2]; // row 2
   assign rotL_r3[3] = Cnt[2] ? rotL_r2[15] : rotL_r2[3]; // row 3
   assign rotL_r3[4] = Cnt[2] ? rotL_r2[0] : rotL_r2[4]; // row 4
   assign rotL_r3[5] = Cnt[2] ? rotL_r2[1] : rotL_r2[5]; // row 5
   assign rotL_r3[6] = Cnt[2] ? rotL_r2[2] : rotL_r2[6]; // row 6
   assign rotL_r3[7] = Cnt[2] ? rotL_r2[3] : rotL_r2[7]; // row 7
   assign rotL_r3[8] = Cnt[2] ? rotL_r2[4] : rotL_r2[8]; // row 8
   assign rotL_r3[9] = Cnt[2] ? rotL_r2[5] : rotL_r2[9]; // row 9
   assign rotL_r3[10] = Cnt[2] ? rotL_r2[6] : rotL_r2[10]; // row 10
   assign rotL_r3[11] = Cnt[2] ? rotL_r2[7] : rotL_r2[11]; // row 11
   assign rotL_r3[12] = Cnt[2] ? rotL_r2[8] : rotL_r2[12]; // row 12
   assign rotL_r3[13] = Cnt[2] ? rotL_r2[9] : rotL_r2[13]; // row 13
   assign rotL_r3[14] = Cnt[2] ? rotL_r2[10] : rotL_r2[14]; // row 14
   assign rotL_r3[15] = Cnt[2] ? rotL_r2[11] : rotL_r2[15]; // row 15

   //column 4
   assign rotL_r4[0] = Cnt[3] ? rotL_r3[8] : rotL_r3[0]; // row 0
   assign rotL_r4[1] = Cnt[3] ? rotL_r3[9] : rotL_r3[1]; // row 1
   assign rotL_r4[2] = Cnt[3] ? rotL_r3[10] : rotL_r3[2]; // row 2
   assign rotL_r4[3] = Cnt[3] ? rotL_r3[11] : rotL_r3[3]; // row 3
   assign rotL_r4[4] = Cnt[3] ? rotL_r3[12] : rotL_r3[4]; // row 4
   assign rotL_r4[5] = Cnt[3] ? rotL_r3[13] : rotL_r3[5]; // row 5
   assign rotL_r4[6] = Cnt[3] ? rotL_r3[14] : rotL_r3[6]; // row 6
   assign rotL_r4[7] = Cnt[3] ? rotL_r3[15] : rotL_r3[7]; // row 7
   assign rotL_r4[8] = Cnt[3] ? rotL_r3[0] : rotL_r3[8]; // row 8
   assign rotL_r4[9] = Cnt[3] ? rotL_r3[1] : rotL_r3[9]; // row 9
   assign rotL_r4[10] = Cnt[3] ? rotL_r3[2] : rotL_r3[10]; // row 10
   assign rotL_r4[11] = Cnt[3] ? rotL_r3[3] : rotL_r3[11]; // row 11
   assign rotL_r4[12] = Cnt[3] ? rotL_r3[4] : rotL_r3[12]; // row 12
   assign rotL_r4[13] = Cnt[3] ? rotL_r3[5] : rotL_r3[13]; // row 13
   assign rotL_r4[14] = Cnt[3] ? rotL_r3[6] : rotL_r3[14]; // row 14
   assign rotL_r4[15] = Cnt[3] ? rotL_r3[7] : rotL_r3[15]; // row 15

   /////////////////////////////////////////////////////////////////
   //////////// SHIFT LEFT ////////////////////////////////////////
   ////////////////////////////////////////////////////////////////
   // column 1
   assign shftL_r1[0] = Cnt[0] ? 1'b0 : In[0]; // row 0
   assign shftL_r1[1] = Cnt[0] ? In[0] : In[1]; // row 1
   assign shftL_r1[2] = Cnt[0] ? In[1] : In[2]; // row 2
   assign shftL_r1[3] = Cnt[0] ? In[2] : In[3]; // row 3
   assign shftL_r1[4] = Cnt[0] ? In[3] : In[4]; // row 4
   assign shftL_r1[5] = Cnt[0] ? In[4] : In[5]; // row 5
   assign shftL_r1[6] = Cnt[0] ? In[5] : In[6]; // row 6
   assign shftL_r1[7] = Cnt[0] ? In[6] : In[7]; // row 7
   assign shftL_r1[8] = Cnt[0] ? In[7] : In[8]; // row 8
   assign shftL_r1[9] = Cnt[0] ? In[8] : In[9]; // row 9
   assign shftL_r1[10] = Cnt[0] ? In[9] : In[10]; // row 10
   assign shftL_r1[11] = Cnt[0] ? In[10] : In[11]; // row 11
   assign shftL_r1[12] = Cnt[0] ? In[11] : In[12]; // row 12
   assign shftL_r1[13] = Cnt[0] ? In[12] : In[13]; // row 13
   assign shftL_r1[14] = Cnt[0] ? In[13] : In[14]; // row 14
   assign shftL_r1[15] = Cnt[0] ? In[14] : In[15]; // row 15

   //column 2
   assign shftL_r2[0] = Cnt[1] ? 1'b0 : shftL_r1[0]; // row 0
   assign shftL_r2[1] = Cnt[1] ? 1'b0 : shftL_r1[1]; // row 1
   assign shftL_r2[2] = Cnt[1] ? shftL_r1[0] : shftL_r1[2]; // row 2
   assign shftL_r2[3] = Cnt[1] ? shftL_r1[1] : shftL_r1[3]; // row 3
   assign shftL_r2[4] = Cnt[1] ? shftL_r1[2] : shftL_r1[4]; // row 4
   assign shftL_r2[5] = Cnt[1] ? shftL_r1[3] : shftL_r1[5]; // row 5
   assign shftL_r2[6] = Cnt[1] ? shftL_r1[4] : shftL_r1[6]; // row 6
   assign shftL_r2[7] = Cnt[1] ? shftL_r1[5] : shftL_r1[7]; // row 7
   assign shftL_r2[8] = Cnt[1] ? shftL_r1[6] : shftL_r1[8]; // row 8
   assign shftL_r2[9] = Cnt[1] ? shftL_r1[7] : shftL_r1[9]; // row 9
   assign shftL_r2[10] = Cnt[1] ? shftL_r1[8] : shftL_r1[10]; // row 10
   assign shftL_r2[11] = Cnt[1] ? shftL_r1[9] : shftL_r1[11]; // row 11
   assign shftL_r2[12] = Cnt[1] ? shftL_r1[10] : shftL_r1[12]; // row 12
   assign shftL_r2[13] = Cnt[1] ? shftL_r1[11] : shftL_r1[13]; // row 13
   assign shftL_r2[14] = Cnt[1] ? shftL_r1[12] : shftL_r1[14]; // row 14
   assign shftL_r2[15] = Cnt[1] ? shftL_r1[13] : shftL_r1[15]; // row 15


   //column 3
   assign shftL_r3[0] = Cnt[2] ? 1'b0 : shftL_r2[0]; // row 0
   assign shftL_r3[1] = Cnt[2] ? 1'b0 : shftL_r2[1]; // row 1
   assign shftL_r3[2] = Cnt[2] ? 1'b0 : shftL_r2[2]; // row 2
   assign shftL_r3[3] = Cnt[2] ? 1'b0 : shftL_r2[3]; // row 3
   assign shftL_r3[4] = Cnt[2] ? shftL_r2[0] : shftL_r2[4]; // row 4
   assign shftL_r3[5] = Cnt[2] ? shftL_r2[1] : shftL_r2[5]; // row 5
   assign shftL_r3[6] = Cnt[2] ? shftL_r2[2] : shftL_r2[6]; // row 6
   assign shftL_r3[7] = Cnt[2] ? shftL_r2[3] : shftL_r2[7]; // row 7
   assign shftL_r3[8] = Cnt[2] ? shftL_r2[4] : shftL_r2[8]; // row 8
   assign shftL_r3[9] = Cnt[2] ? shftL_r2[5] : shftL_r2[9]; // row 9
   assign shftL_r3[10] = Cnt[2] ? shftL_r2[6] : shftL_r2[10]; // row 10
   assign shftL_r3[11] = Cnt[2] ? shftL_r2[7] : shftL_r2[11]; // row 11
   assign shftL_r3[12] = Cnt[2] ? shftL_r2[8] : shftL_r2[12]; // row 12
   assign shftL_r3[13] = Cnt[2] ? shftL_r2[9] : shftL_r2[13]; // row 13
   assign shftL_r3[14] = Cnt[2] ? shftL_r2[10] : shftL_r2[14]; // row 14
   assign shftL_r3[15] = Cnt[2] ? shftL_r2[11] : shftL_r2[15]; // row 15


   //column 4
   assign shftL_r4[0] = Cnt[3] ? 1'b0 : shftL_r3[0]; // row 0
   assign shftL_r4[1] = Cnt[3] ? 1'b0 : shftL_r3[1]; // row 1
   assign shftL_r4[2] = Cnt[3] ? 1'b0 : shftL_r3[2]; // row 2
   assign shftL_r4[3] = Cnt[3] ? 1'b0 : shftL_r3[3]; // row 3
   assign shftL_r4[4] = Cnt[3] ? 1'b0 : shftL_r3[4]; // row 4
   assign shftL_r4[5] = Cnt[3] ? 1'b0 : shftL_r3[5]; // row 5
   assign shftL_r4[6] = Cnt[3] ? 1'b0 : shftL_r3[6]; // row 6
   assign shftL_r4[7] = Cnt[3] ? 1'b0 : shftL_r3[7]; // row 7
   assign shftL_r4[8] = Cnt[3] ? shftL_r3[0] : shftL_r3[8]; // row 8
   assign shftL_r4[9] = Cnt[3] ? shftL_r3[1] : shftL_r3[9]; // row 9
   assign shftL_r4[10] = Cnt[3] ? shftL_r3[2] : shftL_r3[10]; // row 10
   assign shftL_r4[11] = Cnt[3] ? shftL_r3[3] : shftL_r3[11]; // row 11
   assign shftL_r4[12] = Cnt[3] ? shftL_r3[4] : shftL_r3[12]; // row 12
   assign shftL_r4[13] = Cnt[3] ? shftL_r3[5] : shftL_r3[13]; // row 13
   assign shftL_r4[14] = Cnt[3] ? shftL_r3[6] : shftL_r3[14]; // row 14
   assign shftL_r4[15] = Cnt[3] ? shftL_r3[7] : shftL_r3[15]; // row 15

   ////////////////////////////////////////////////////////////////////////////
   //////////// SHIFT Right Arithmetic ////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////

   // column 1
   assign shftRA_r1[0] = Cnt[0] ? In[1] : In[0]; // row 0
   assign shftRA_r1[1] = Cnt[0] ? In[2] : In[1]; // row 1
   assign shftRA_r1[2] = Cnt[0] ? In[3] : In[2]; // row 2
   assign shftRA_r1[3] = Cnt[0] ? In[4] : In[3]; // row 3
   assign shftRA_r1[4] = Cnt[0] ? In[5] : In[4]; // row 4
   assign shftRA_r1[5] = Cnt[0] ? In[6] : In[5]; // row 5
   assign shftRA_r1[6] = Cnt[0] ? In[7] : In[6]; // row 6
   assign shftRA_r1[7] = Cnt[0] ? In[8] : In[7]; // row 7
   assign shftRA_r1[8] = Cnt[0] ? In[9] : In[8]; // row 8
   assign shftRA_r1[9] = Cnt[0] ? In[10] : In[9]; // row 9
   assign shftRA_r1[10] = Cnt[0] ? In[11] : In[10]; // row 10
   assign shftRA_r1[11] = Cnt[0] ? In[12] : In[11]; // row 11
   assign shftRA_r1[12] = Cnt[0] ? In[13] : In[12]; // row 12
   assign shftRA_r1[13] = Cnt[0] ? In[14] : In[13]; // row 13
   assign shftRA_r1[14] = Cnt[0] ? In[15] : In[14]; // row 14
   assign shftRA_r1[15] = Cnt[0] ? In[15] : In[15]; // row 15

   // column 2
   assign shftRA_r2[0] = Cnt[1] ? shftRA_r1[2] : shftRA_r1[0]; // row 0
   assign shftRA_r2[1] = Cnt[1] ? shftRA_r1[3] : shftRA_r1[1]; // row 1
   assign shftRA_r2[2] = Cnt[1] ? shftRA_r1[4] : shftRA_r1[2]; // row 2
   assign shftRA_r2[3] = Cnt[1] ? shftRA_r1[5] : shftRA_r1[3]; // row 3
   assign shftRA_r2[4] = Cnt[1] ? shftRA_r1[6] : shftRA_r1[4]; // row 4
   assign shftRA_r2[5] = Cnt[1] ? shftRA_r1[7] : shftRA_r1[5]; // row 5
   assign shftRA_r2[6] = Cnt[1] ? shftRA_r1[8] : shftRA_r1[6]; // row 6
   assign shftRA_r2[7] = Cnt[1] ? shftRA_r1[9] : shftRA_r1[7]; // row 7
   assign shftRA_r2[8] = Cnt[1] ? shftRA_r1[10] : shftRA_r1[8]; // row 8
   assign shftRA_r2[9] = Cnt[1] ? shftRA_r1[11] : shftRA_r1[9]; // row 9
   assign shftRA_r2[10] = Cnt[1] ? shftRA_r1[12] : shftRA_r1[10]; // row 10
   assign shftRA_r2[11] = Cnt[1] ? shftRA_r1[13] : shftRA_r1[11]; // row 11
   assign shftRA_r2[12] = Cnt[1] ? shftRA_r1[14] : shftRA_r1[12]; // row 12
   assign shftRA_r2[13] = Cnt[1] ? shftRA_r1[15] : shftRA_r1[13]; // row 13
   assign shftRA_r2[14] = Cnt[1] ? shftRA_r1[15] : shftRA_r1[14]; // row 14
   assign shftRA_r2[15] = Cnt[1] ? shftRA_r1[15] : shftRA_r1[15]; // row 15

   // column 3
   assign shftRA_r3[0] = Cnt[2] ? shftRA_r2[4] : shftRA_r2[0]; // row 0
   assign shftRA_r3[1] = Cnt[2] ? shftRA_r2[5] : shftRA_r2[1]; // row 1
   assign shftRA_r3[2] = Cnt[2] ? shftRA_r2[6] : shftRA_r2[2]; // row 2
   assign shftRA_r3[3] = Cnt[2] ? shftRA_r2[7] : shftRA_r2[3]; // row 3
   assign shftRA_r3[4] = Cnt[2] ? shftRA_r2[8] : shftRA_r2[4]; // row 4
   assign shftRA_r3[5] = Cnt[2] ? shftRA_r2[9] : shftRA_r2[5]; // row 5
   assign shftRA_r3[6] = Cnt[2] ? shftRA_r2[10] : shftRA_r2[6]; // row 6
   assign shftRA_r3[7] = Cnt[2] ? shftRA_r2[11] : shftRA_r2[7]; // row 7
   assign shftRA_r3[8] = Cnt[2] ? shftRA_r2[12] : shftRA_r2[8]; // row 8
   assign shftRA_r3[9] = Cnt[2] ? shftRA_r2[13] : shftRA_r2[9]; // row 9
   assign shftRA_r3[10] = Cnt[2] ? shftRA_r2[14] : shftRA_r2[10]; // row 10
   assign shftRA_r3[11] = Cnt[2] ? shftRA_r2[15] : shftRA_r2[11]; // row 11
   assign shftRA_r3[12] = Cnt[2] ? shftRA_r2[15] : shftRA_r2[12]; // row 12
   assign shftRA_r3[13] = Cnt[2] ? shftRA_r2[15] : shftRA_r2[13]; // row 13
   assign shftRA_r3[14] = Cnt[2] ? shftRA_r2[15] : shftRA_r2[14]; // row 14
   assign shftRA_r3[15] = Cnt[2] ? shftRA_r2[15] : shftRA_r2[15]; // row 15

   // column 4
   assign shftRA_r4[0] = Cnt[3] ? shftRA_r3[8] : shftRA_r3[0]; // row 0
   assign shftRA_r4[1] = Cnt[3] ? shftRA_r3[9] : shftRA_r3[1]; // row 1
   assign shftRA_r4[2] = Cnt[3] ? shftRA_r3[10] : shftRA_r3[2]; // row 2
   assign shftRA_r4[3] = Cnt[3] ? shftRA_r3[11] : shftRA_r3[3]; // row 3
   assign shftRA_r4[4] = Cnt[3] ? shftRA_r3[12] : shftRA_r3[4]; // row 4
   assign shftRA_r4[5] = Cnt[3] ? shftRA_r3[13] : shftRA_r3[5]; // row 5
   assign shftRA_r4[6] = Cnt[3] ? shftRA_r3[14] : shftRA_r3[6]; // row 6
   assign shftRA_r4[7] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[7]; // row 7
   assign shftRA_r4[8] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[8]; // row 8
   assign shftRA_r4[9] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[9]; // row 9
   assign shftRA_r4[10] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[10]; // row 10
   assign shftRA_r4[11] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[11]; // row 11
   assign shftRA_r4[12] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[12]; // row 12
   assign shftRA_r4[13] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[13]; // row 13
   assign shftRA_r4[14] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[14]; // row 14
   assign shftRA_r4[15] = Cnt[3] ? shftRA_r3[15] : shftRA_r3[15]; // row 15

   ////////////////////////////////////////////////////////////////////////
   ///////////////////// Shift Right Logical //////////////////////////////
   ///////////////////////////////////////////////////////////////////////

   // column 1
   assign shftRL_r1[0] = Cnt[0] ? In[1] : In[0]; // row 0
   assign shftRL_r1[1] = Cnt[0] ? In[2] : In[1]; // row 1
   assign shftRL_r1[2] = Cnt[0] ? In[3] : In[2]; // row 2
   assign shftRL_r1[3] = Cnt[0] ? In[4] : In[3]; // row 3
   assign shftRL_r1[4] = Cnt[0] ? In[5] : In[4]; // row 4
   assign shftRL_r1[5] = Cnt[0] ? In[6] : In[5]; // row 5
   assign shftRL_r1[6] = Cnt[0] ? In[7] : In[6]; // row 6
   assign shftRL_r1[7] = Cnt[0] ? In[8] : In[7]; // row 7
   assign shftRL_r1[8] = Cnt[0] ? In[9] : In[8]; // row 8
   assign shftRL_r1[9] = Cnt[0] ? In[10] : In[9]; // row 9
   assign shftRL_r1[10] = Cnt[0] ? In[11] : In[10]; // row 10
   assign shftRL_r1[11] = Cnt[0] ? In[12] : In[11]; // row 11
   assign shftRL_r1[12] = Cnt[0] ? In[13] : In[12]; // row 12
   assign shftRL_r1[13] = Cnt[0] ? In[14] : In[13]; // row 13
   assign shftRL_r1[14] = Cnt[0] ? In[15] : In[14]; // row 14
   assign shftRL_r1[15] = Cnt[0] ? 1'b0 : In[15]; // row 15

   // column 2
   assign shftRL_r2[0] = Cnt[1] ? shftRL_r1[2] : shftRL_r1[0]; // row 0
   assign shftRL_r2[1] = Cnt[1] ? shftRL_r1[3] : shftRL_r1[1]; // row 1
   assign shftRL_r2[2] = Cnt[1] ? shftRL_r1[4] : shftRL_r1[2]; // row 2
   assign shftRL_r2[3] = Cnt[1] ? shftRL_r1[5] : shftRL_r1[3]; // row 3
   assign shftRL_r2[4] = Cnt[1] ? shftRL_r1[6] : shftRL_r1[4]; // row 4
   assign shftRL_r2[5] = Cnt[1] ? shftRL_r1[7] : shftRL_r1[5]; // row 5
   assign shftRL_r2[6] = Cnt[1] ? shftRL_r1[8] : shftRL_r1[6]; // row 6
   assign shftRL_r2[7] = Cnt[1] ? shftRL_r1[9] : shftRL_r1[7]; // row 7
   assign shftRL_r2[8] = Cnt[1] ? shftRL_r1[10] : shftRL_r1[8]; // row 8
   assign shftRL_r2[9] = Cnt[1] ? shftRL_r1[11] : shftRL_r1[9]; // row 9
   assign shftRL_r2[10] = Cnt[1] ? shftRL_r1[12] : shftRL_r1[10]; // row 10
   assign shftRL_r2[11] = Cnt[1] ? shftRL_r1[13] : shftRL_r1[11]; // row 11
   assign shftRL_r2[12] = Cnt[1] ? shftRL_r1[14] : shftRL_r1[12]; // row 12
   assign shftRL_r2[13] = Cnt[1] ? shftRL_r1[15] : shftRL_r1[13]; // row 13
   assign shftRL_r2[14] = Cnt[1] ? 1'b0 : shftRL_r1[14]; // row 14
   assign shftRL_r2[15] = Cnt[1] ? 1'b0 : shftRL_r1[15]; // row 15

   // column 3
   assign shftRL_r3[0] = Cnt[2] ? shftRL_r2[4] : shftRL_r2[0]; // row 0
   assign shftRL_r3[1] = Cnt[2] ? shftRL_r2[5] : shftRL_r2[1]; // row 1
   assign shftRL_r3[2] = Cnt[2] ? shftRL_r2[6] : shftRL_r2[2]; // row 2
   assign shftRL_r3[3] = Cnt[2] ? shftRL_r2[7] : shftRL_r2[3]; // row 3
   assign shftRL_r3[4] = Cnt[2] ? shftRL_r2[8] : shftRL_r2[4]; // row 4
   assign shftRL_r3[5] = Cnt[2] ? shftRL_r2[9] : shftRL_r2[5]; // row 5
   assign shftRL_r3[6] = Cnt[2] ? shftRL_r2[10] : shftRL_r2[6]; // row 6
   assign shftRL_r3[7] = Cnt[2] ? shftRL_r2[11] : shftRL_r2[7]; // row 7
   assign shftRL_r3[8] = Cnt[2] ? shftRL_r2[12] : shftRL_r2[8]; // row 8
   assign shftRL_r3[9] = Cnt[2] ? shftRL_r2[13] : shftRL_r2[9]; // row 9
   assign shftRL_r3[10] = Cnt[2] ? shftRL_r2[14] : shftRL_r2[10]; // row 10
   assign shftRL_r3[11] = Cnt[2] ? shftRL_r2[15] : shftRL_r2[11]; // row 11
   assign shftRL_r3[12] = Cnt[2] ? 1'b0 : shftRL_r2[12]; // row 12
   assign shftRL_r3[13] = Cnt[2] ? 1'b0 : shftRL_r2[13]; // row 13
   assign shftRL_r3[14] = Cnt[2] ? 1'b0 : shftRL_r2[14]; // row 14
   assign shftRL_r3[15] = Cnt[2] ? 1'b0 : shftRL_r2[15]; // row 15

   // column 4
   assign shftRL_r4[0] = Cnt[3] ? shftRL_r3[8] : shftRL_r3[0]; // row 0
   assign shftRL_r4[1] = Cnt[3] ? shftRL_r3[9] : shftRL_r3[1]; // row 1
   assign shftRL_r4[2] = Cnt[3] ? shftRL_r3[10] : shftRL_r3[2]; // row 2
   assign shftRL_r4[3] = Cnt[3] ? shftRL_r3[11] : shftRL_r3[3]; // row 3
   assign shftRL_r4[4] = Cnt[3] ? shftRL_r3[12] : shftRL_r3[4]; // row 4
   assign shftRL_r4[5] = Cnt[3] ? shftRL_r3[13] : shftRL_r3[5]; // row 5
   assign shftRL_r4[6] = Cnt[3] ? shftRL_r3[14] : shftRL_r3[6]; // row 6
   assign shftRL_r4[7] = Cnt[3] ? shftRL_r3[15] : shftRL_r3[7]; // row 7
   assign shftRL_r4[8] = Cnt[3] ? 1'b0 : shftRL_r3[8]; // row 8
   assign shftRL_r4[9] = Cnt[3] ? 1'b0 : shftRL_r3[9]; // row 9
   assign shftRL_r4[10] = Cnt[3] ? 1'b0 : shftRL_r3[10]; // row 10
   assign shftRL_r4[11] = Cnt[3] ? 1'b0 : shftRL_r3[11]; // row 11
   assign shftRL_r4[12] = Cnt[3] ? 1'b0 : shftRL_r3[12]; // row 12
   assign shftRL_r4[13] = Cnt[3] ? 1'b0 : shftRL_r3[13]; // row 13
   assign shftRL_r4[14] = Cnt[3] ? 1'b0 : shftRL_r3[14]; // row 14
   assign shftRL_r4[15] = Cnt[3] ? 1'b0 : shftRL_r3[15]; // row 15

   // assign out
   assign Out = Op[1] ? (Op[0] ? shftRL_r4 : shftRA_r4 ) : (Op[0] ? shftL_r4 : rotL_r4 );
   
endmodule

