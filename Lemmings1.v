//The game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine.

//In the Lemmings' 2D world, Lemmings can be in one of two states: walking left or walking right. It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left, it will walk right. If it's bumped on the right, it will walk left. If it's bumped on both sides at the same time, it will still switch directions.

//Implement a Moore state machine with two states, two inputs, and one output that models this behaviour.


module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  
	
    parameter LEFT=0, RIGHT=1;
    reg state, next_state;
    
    always @(*) begin
        // State transition logic
        case(state)
            LEFT : if(bump_left == 1) begin
            		next_state = RIGHT;
            end
            else
                	next_state = LEFT;
            
            RIGHT : if(bump_right == 1) begin
                	next_state = LEFT;
            end
            else
                	next_state = RIGHT;
            
            //BOTH : if( bump_right == 1 && bump_left == 1) begin
             //   	next_state = 
            default : next_state = LEFT;
        endcase
        
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin
        state = LEFT;
        end
        else
            state = next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT) ? 1 : 0;
    assign walk_right = (state == RIGHT) ? 1 : 0;

endmodule
