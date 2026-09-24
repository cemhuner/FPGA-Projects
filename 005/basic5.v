

// common mistakes

// y variable shared by two always block
reg y;
reg a, b, clear;

always @* 
    if (clear) y = 1'b0;

always @*
    y = a & b;

// we must group them
always @*
    if (clear) 
        y = 1'b0;
    else
        y = a & b;

// @* implicitly include all the relevant
// input signals when used in always block

// incomplete output assignment

always @*
    if (a > b)
        gt = 1'b1;
    else if (a == b)
        eq = 1'b1;

// always assign a default value to each variable

always @* begin
        gt = l'bO; // default value for gt
        eq = l'bO; // default value for eq
    if (a > b)
        gt = l'bl;
    else if (a == b)
        eq = l'bl;
end

