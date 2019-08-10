module vendingmachine2(a,b,c,choice,coin,clock,rst);
output reg a,b,c ;
input [3:0] choice;
input [3:0] coin ;
input clock,rst ;
parameter get_a=4'd0 , get_b=4'd1 , get_c=4'd2 , q1=4'd3 , q2=4'd4 , d1=4'd5 , n1=4'd6 , do1=4'd7 , do2=4'd8 , q3=4'd9 , q4=4'd10 , wrongchoice=4'd11;
reg [3:0] present, next;

always @(choice)
begin
  case(choice)
    get_a: present=get_a;
    get_b: present=get_b;
    get_c: present=get_c;
    default: present=wrongchoice;
  endcase
end

always @ (*)
begin
a=1'b0;
b=1'b0;
c=1'b0;
 if(choice == get_a)
    begin
    a=1'b0;
    case(present)
		get_a :next<= coin ? q1 : get_a ;
		q1    :next<=  coin ? q2: get_a ;
		q2    :next<= coin  ? d1 : get_a ;
		d1    :next<= coin ? n1 :  get_a ;
		n1: begin
				a=1'b1;
				next<=choice ;
			  end
		default : begin
		          next<=4'bxxxx;
		          end
         endcase
    end

else if(choice == get_b)
    begin b=1'b0;
         if(coin == do1)
		        begin
		        b=1'b1;
         			next<=choice ;
		        end
    end
    
else if(choice == get_c)
    begin
    c=1'b0;
    case(present)
		get_c : next<= coin ? do2 : get_c ;
		do2    : next<=  coin ? q3: get_c ;
		q3    : next<= coin  ? q4 : get_c ;
		q4    : begin
				c=1'b1;
				next<=choice;
			 end
		default : begin
		          next<=4'bxxxx;
		          end
         endcase
    end
 else
       begin
           next<=wrongchoice;
       end
end

always @ (posedge clock)
begin 
 if(rst == 1)
    present=0;
 else
    present=next;
end
endmodule

module vendingmachine2tb();
wire a,b,c ;
reg [3:0] choice , coin ;
reg clock, rst;

vendingmachine2 vm2(a,b,c,choice,coin,clock,rst);


initial
begin
clock=0;
rst=1;
#20 rst=0;
end

always
#10 clock=~clock ;

initial
begin
  choice=4'd0;
 #20 coin=4'd3;
 #20 coin=4'd4;
 #20 coin=4'd5;
 #20 coin=4'd6;

 #30 choice=4'd1;
 #20 coin=4'd7;

 #20 choice=4'd2;
 #20 coin=4'd8;
 #20 coin=4'd9;
 #20 coin=4'd10;
end
endmodule