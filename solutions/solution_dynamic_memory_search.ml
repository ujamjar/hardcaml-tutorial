open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  open Dynamic_memory_search
  open I
  open O

  let f i = 
    let read = wire n in
    let q = Seq.memory (1 lsl n) ~we:i.write ~wa:i.addr ~d:i.data ~ra:read in

    let done_ = (~: (i.start)) &: (q ==: i.data) in
    let target = Seq.reg_fb ~e:vdd ~w:n 
      (fun d ->
        pmux [
          i.start |: i.write, zero n;
          ~: done_, d +:. 1;
        ] d)
    in
    let () = read <== target in

    { target; done_ }

end

let test () = 
  let module C = Checksim.Make(B)(Dynamic_memory_search.I)(Dynamic_memory_search.O) in
  let open Dynamic_memory_search.I in
  let open Dynamic_memory_search.O in

  let i,o,_,reset,cycle,waves = C.make Solution.f Dynamic_memory_search.search in

  reset ();
  
  i.write := B.vdd;
  for j=0 to 15 do
    i.addr := B.consti 4 j;
    i.data := B.consti 8 (j*10);
    cycle ()
  done;
  i.write := B.gnd;

  i.start := B.vdd;
  i.data := B.consti 8 90;
  cycle ();
  i.start := B.gnd;
  while B.to_int !(o.done_) = 0 do
    cycle ()
  done;
  waves ()

let dynamic_memory_search_tutorial = "dynamic_memory_search", (fun () -> test ())

