# Day27 Vivado project generator for the KV260 accelerator MVP.
set project_name "ai_accelerator_kv260"
set project_dir "./vivado/$project_name"
set part_name "xck26-sfvc784-2LV-c"
set board_name "xilinx.com:kv260_som:part0:1.4"

create_project $project_name $project_dir -part $part_name -force
set_property board_part $board_name [current_project]
set_property target_language Verilog [current_project]

add_files [list \
  [file normalize "../../RTL/Day24/ai_accelerator_mvp.v"] \
  [file normalize "../../RTL/Day23/npu_wstore_top.v"] \
  [file normalize "../../RTL/Day19/systolic_matmul.v"] \
  [file normalize "../../RTL/Day14/Compute/pe_unit.v"] \
  [file normalize "../../RTL/Day21/fetch16w.v"] \
  [file normalize "../../RTL/Day14/Memory/weight_buffer.v"] \
  [file normalize "../../RTL/Day14/Memory/activation_buffer.v"] \
  [file normalize "../../RTL/Day14/Memory/output_buffer.v"] \
  [file normalize "kv260_accelerator_top.v"] \
]
add_files -fileset constrs_1 [file normalize "kv260_accelerator.xdc"]
set_property top kv260_accelerator_top [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
save_project_as $project_name [file normalize $project_dir]
puts "KV260 project skeleton created: $project_name"
