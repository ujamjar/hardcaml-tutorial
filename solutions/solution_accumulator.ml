open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  open Accumulator
  open I
  open O

  let f i = 
    let d = Seq.(reg_fb ~e:i.input ~w:8 (fun d -> d +:. 1)) in
    { output = d }

end

let test () = 
  let module C = Checksim.Make(B)(Accumulator.I)(Accumulator.O) in
  let open Accumulator.I in
  let open Accumulator.O in

  let i,o,_,reset,cycle,waves = C.make Solution.f Accumulator.accumulator in

  reset ();
  for j=0 to 9 do
    i.input := B.srand 1;
    cycle ()
  done;
  waves ()

let accumulator_tutorial = "accumulator", (fun () -> test ())

