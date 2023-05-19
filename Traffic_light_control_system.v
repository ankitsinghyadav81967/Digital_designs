// Code your design here
//Given below code is design code for Traffic Light Controller using Finite State Machine(FSM). In this clk and rst_a are two input signal and n_lights, s_lights, e_lights and w_lights are 3 bit output signal. In output signal, "001" represents Green light, "010" represents Yellow light and "100" represents Red light. On the reset signal, design will enter into north state and start giving output after reset will go low. Design will turn on Green light for eight clock cycles and Yellow light for four clock cycles. Design will start with north, then goes into south, then east and finally into west and by this it will keep going.


module traffic_control(n_lights,s_lights,e_lights,w_lights,clk,rst_a);

   output reg [2:0] n_lights,s_lights,e_lights,w_lights; 
   input      clk;
   input      rst_a;
 
   reg [2:0] state;
 
   parameter [2:0] north=3'b000;
   parameter [2:0] north_y=3'b001;
   parameter [2:0] south=3'b010;
   parameter [2:0] south_y=3'b011;
   parameter [2:0] east=3'b100;
   parameter [2:0] east_y=3'b101;
   parameter [2:0] west=3'b110;
   parameter [2:0] west_y=3'b111;

   reg [2:0] count;
 

   always @(posedge clk, posedge rst_a)
     begin
        if (rst_a)
            begin
                state=north;
                count =3'b000;
            end
        else
            begin
                case (state)
                north :
                    begin
                        if (count==3'b111)
                            begin
                            count=3'b000;
                            state=north_y;
                            end
                        else
                            begin
                            count=count+3'b001;
                            state=north;
                            end
                    end

                north_y :
                    begin
                        if (count==3'b011)
                            begin
                            count=3'b000;
                            state=south;
                            end
                        else
                            begin
                            count=count+3'b001;
                            state=north_y;
                        end
                    end

               south :
                    begin
                        if (count==3'b111)
                            begin
                            count=3'b0;
                            state=south_y;
                            end
                        else
                            begin
                            count=count+3'b001;
                            state=south;
                        end
                    end

            south_y :
                begin
                    if (count==3'b011)
                        begin
                        count=3'b0;
                        state=east;
                        end
                    else
                        begin
                        count=count+3'b001;
                        state=south_y;
                        end
                    end

            east :
                begin
                    if (count==3'b111)
                        begin
                        count=3'b0;
                        state=east_y;
                        end
                    else
                        begin
                        count=count+3'b001;
                        state=east;
                        end
                    end

            east_y :
                begin
                    if (count==3'b011)
                        begin
                        count=3'b0;
                        state=west;
                        end
                    else
                        begin
                        count=count+3'b001;
                        state=east_y;
                        end
                    end

            west :
                begin
                    if (count==3'b111)
                        begin
                        state=west_y;
                        count=3'b0;
                        end
                    else
                        begin
                        count=count+3'b001;
                        state=west;
                        end
                    end

            west_y :
                begin
                    if (count==3'b011)
                        begin
                        state=north;
                        count=3'b0;
                        end
                    else
                        begin
                        count=count+3'b001;
                        state=west_y;
                        end
                    end
            endcase // case (state)
        end // always @ (state)
    end 


always @(state)
     begin
         case (state)
            north :
                begin
                    n_lights = 3'b001;
                    s_lights = 3'b100;
                    e_lights = 3'b100;
                    w_lights = 3'b100;
                end // case: north

            north_y :
                begin
                    n_lights = 3'b010;
                    s_lights = 3'b100;
                    e_lights = 3'b100;
                    w_lights = 3'b100;
                end // case: north_y

            south :
                begin
                    n_lights = 3'b100;
                    s_lights = 3'b001;
                    e_lights = 3'b100;
                    w_lights = 3'b100;
                end // case: south

            south_y :
                begin
                    n_lights = 3'b100;
                    s_lights = 3'b010;
                    e_lights = 3'b100;
                    w_lights = 3'b100;
                end // case: south_y

            west :
                begin
                    n_lights = 3'b100;
                    s_lights = 3'b100;
                    e_lights = 3'b100;
                    w_lights = 3'b001;
                end // case: west

            west_y :
                begin
                    n_lights = 3'b100;
                    s_lights = 3'b100;
                    e_lights = 3'b100;
                    w_lights = 3'b010;
                end // case: west_y

            east :
                begin
                    n_lights = 3'b100;
                    s_lights = 3'b100;
                    e_lights = 3'b001;
                    w_lights = 3'b100;
                end // case: east

            east_y :
                begin
                    n_lights = 3'b100;
                    s_lights = 3'b100;
                    e_lights = 3'b010;
                    w_lights = 3'b100;
                end // case: east_y
            endcase // case (state)
     end // always @ (state)
endmodule
