
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name CS56-FinalProject -dir "O:/engs31/CS56-FinalProject/planAhead_run_2" -part xc6slx16csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "O:/engs31/CS56-FinalProject/Keyboard_TOP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {O:/engs31/CS56-FinalProject} {ipcore_dir} }
add_files [list {ipcore_dir/SineWave.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "Nexys3_Master.ucf" [current_fileset -constrset]
add_files [list {Nexys3_Master.ucf}] -fileset [get_property constrset [current_run]]
link_design
