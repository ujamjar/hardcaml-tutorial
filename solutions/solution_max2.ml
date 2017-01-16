open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  module I = struct
    type 'a t = {
      a : 'a[@bits 8];
      b : 'a[@bits 8];
    }[@@deriving hardcaml]
  end

  module O = struct
    type 'a t = {
      c : 'a[@bits 8];
    }[@@deriving hardcaml]
  end

  let f i = { O.c = mux2 (i.I.a >: i.I.b) i.I.a i.I.b }

end

let test () = 
  let open Solution in
  let module C = Checksim.Make(B)(I)(O) in
  let open I in
  let open O in

  let i,o,_,reset,cycle,waves = C.make Solution.f (fun i -> { c = Max2.max2 i.a i.b }) in
  
  for j=0 to 9 do
    i.a := B.srand 8;
    i.b := B.srand 8;
    cycle ();
  done;
  waves ()

let max2_tutorial = "max2", test

