`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Laura Sabina Bañuelos Zendrero
// 
// Create Date: 30.09.2025 19:06:44
// Design Name: 
// Module Name: BOOTH_MULTIPLICATION
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  
//////////////////////////////////////////////////////////////////////////////////


module sabina_mult#(
    parameter DATA_WIDTH = 8  // NUMBER OF BITS
)(
    // ----------- INPUTS & OUTPUTS -----------------------------------
    input logic  [DATA_WIDTH-1:0] m,                // Multiplicant
    input logic  [DATA_WIDTH-1:0] q,                // Multiplier
    output logic [(2*DATA_WIDTH)-1:0] final_result  // Result
    );  
      
    // -------------- VARIABLES REQUIRED FOR BOOTH'S MULTIPLICATION CYCLE --------------------------------
    logic [DATA_WIDTH-1:0] acumulator_minus_m;  // Subtraction of the Accumulator and the Multiplier
    logic [DATA_WIDTH-1:0] acumulator_plus_m;   // Sum of the Accumulator and the Multiplier
    logic [DATA_WIDTH-1:0] acumulator;          // Acumulator
    logic [(2*DATA_WIDTH):0] shift;             // Concatenated register (a|q|q_minous_one)
    logic [DATA_WIDTH-1:0] q_r;                 // Multiplier used within the multiplier cycle
    logic [DATA_WIDTH-1:0] m_r;                 // Multiplicant used within the multiplier cycle
    logic q_minus_one;                          // Previous bit of q0 (q0-1)
    int  i;                                     // 
    
    
    // ----------------- BOOTH'S MULTIPLICATION CYCLE ------------------------------------------------------------------------       
      always_comb begin     
      
      // Initialization of variables---------------
        q_r = q;
        m_r = m;
        q_minus_one = 'b0;                    
        acumulator_plus_m = 'b0;           
        acumulator_minus_m = 'b0;
        acumulator = 'b0;
        final_result = 'b0;
        shift = {acumulator, q_r, q_minus_one};
        
        // // Start of the cycle---------------------
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin  //For loop that repeats according to the number of bits
          
            acumulator_plus_m = acumulator + m_r;
            acumulator_minus_m = acumulator - m_r;
           
                case (shift[1:0])    //Case with only the last two shift bits indicating which operation will be performed next              
                    2'b10: acumulator = acumulator_minus_m;     // Subtraction of the Accumulator and the Multiplier
                    2'b01: acumulator = acumulator_plus_m;      // Sum of the Accumulator and the Multiplier
                    default: acumulator = acumulator;           // If the bits are equal
                endcase
            
            {acumulator, q_r, q_minus_one} = {acumulator, q_r, q_minus_one} >>> 1;
            acumulator [DATA_WIDTH-1] = acumulator [DATA_WIDTH-2];                  // Accumulator adjustment
            shift = {acumulator, q_r, q_minus_one};
            
        end
         final_result = {acumulator, q_r};          // Concatenation of the final result with sign
    end

    endmodule
