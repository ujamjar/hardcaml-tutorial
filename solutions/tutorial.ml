let tutorials = 
  [
    Solution_accumulator.accumulator_tutorial;
    Solution_adder.adder_tutorial;
    Solution_adder.signed_adder_tutorial;
    Solution_counter.counter_tutorial;
    Solution_dynamic_memory_search.dynamic_memory_search_tutorial;
    Solution_lfsr16.lfsr16_tutorial;
    Solution_max2.max2_tutorial;
    Solution_maxn.maxn_tutorial;
    Solution_table.table_tutorial;
    Solution_prioritymux.prioritymux_tutorial;
    Solution_gcd.gcd_tutorial;
    Solution_vendingmachine.vendingmachine_tutorial;
  ]

let testbench = ref (fun () -> Printf.printf "No test selected.\n")
let sel_testbench = 
  ("-waves", Arg.Set Checksim.show_waves, " Show waveform") ::
  List.map (fun (n,f) -> "-"^n, Arg.Unit(fun () -> testbench := f), " " ^ n ^ " example") tutorials

let () = Arg.(parse (align sel_testbench) (fun _ -> ()) "hardcaml-tutorial")

let () = (!testbench) ()

