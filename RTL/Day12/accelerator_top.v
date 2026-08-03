module accelerator_top #(

parameter DATA_WIDTH = 8,

parameter ACC_WIDTH = 32

)(


input wire clk,

input wire reset,

input wire start,


output wire done,


output wire signed [ACC_WIDTH-1:0]
result [0:3][0:3]

);



wire load_weight;

wire compute;

wire output_valid;

wire clear_acc;



// =================================
// Controller
// =================================


controller_fsm ctrl(

.clk(clk),

.reset(reset),

.start(start),

.load_weight(load_weight),

.compute(compute),

.output_valid(output_valid),

.clear_acc(clear_acc)

);



assign done = output_valid;





// =================================
// Weight Loader
// =================================


wire signed [DATA_WIDTH-1:0]
weight_data [0:3];



weight_loader weight_mem(

.clk(clk),

.reset(reset),

.load(load_weight),

.weight_out(weight_data)

);





// =================================
// Activation Loader
// =================================


wire signed [DATA_WIDTH-1:0]
activation_data [0:3];



activation_loader activation_mem(

.clk(clk),

.reset(reset),

.load(compute),

.activation_out(activation_data)

);





// =================================
// Compute Array
// =================================


systolic_array_4x4 #(

.DATA_WIDTH(DATA_WIDTH),

.ACC_WIDTH(ACC_WIDTH)

)

array_inst

(

.clk(clk),

.reset(reset),

.enable(compute),

.clear_acc(clear_acc),


.activation_in(activation_data),

.weight_in(weight_data),


.result(result)

);



endmodule
