// Code your design here
// Write a State Machine to control a light switch
// - The switch has a motion sensor on it that goes high when motion is detected.
// - The switch automatically turns the lights on when motion is detected.
// - When no motion is detected for 5 mins then the light automatically turns off.

module light_switch #(
  parameter TIMEOUT_IN_MIN = 5
) (
  
  input        clk, // 10 MHz = 100ns 
  input        rstn,
	input        motion_detect, // level signal // 0: no motion, 1:motion
	output logic light_on
);
  
 //S_idle --> //no_motion N   Lights F 
 //S0 -->    //motion M         Lights O
  //S1 -->   // motion N			Lights O
  
  //counter which could count till 5 , it will move to S_idle
  
  parameter S_idle = 0;
  parameter M = 1;  // M = motion detected
  parameter L = 2;  // L = lights on
  parameter T = 3;  // T =  timer will start counting
  
  logic times_up = 1'b1;
  
  reg [1:0] state , next_state ;
  
  always@(*) begin
    case (state)
      S_idle : if(motion_detect == 1'b1) begin
        next_state = M;
        light_on = 1'b1;
      end
      else begin
        next_state = S_idle;
      light_on = 1'b0;
      end
      
      M : if(motion_detect == 1'b0) begin
        next_state = T;
        light_on = 1'b1;
      end 
      else begin
        next_state = M;
        light_on = 1'b1;
      end
      
      L : if(motion_detect == 1'b0) begin
        next_state = T;
      end
      else begin
        next_state = L;
        light_on = 1'b1;
      end
      
      T : if(motion_detect == 1'b1) begin
        next_state = L;
      end
      else if (times_up) begin
        next_state = idle;
        light_on = 1'b0;
      end 
      else begin
        next_state = T;
        light_on = 1'b1;
      end
      
    endcase
  end
  
  always@(posedge clk) begin
    state = next_state;
  end
  
  //evaluating times_up value
  assign times_up = (count == 3'b101) ? 1 :0 ;
  
  
  reg [3:0] count ;
  //initiate a counter
  always@(posedge clk) begin
    if( state == L or state == T) begin
      count <= count + 1;
      end
    else 
        count <= 0;
    end
  
endmodule
      

