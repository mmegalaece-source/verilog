module odd_random;
integer count;
integer num;
initial begin
    count = 0;
    while(count < 5)
    begin
        num = $urandom_range(1,10);
        if(num % 2 != 0)
        begin
            $display("Random odd number = %0d", num);
            count = count + 1;
        end
    end
end
endmodule
