open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  module I = struct
    type 'a t = {
      inputs : 'a list[@bits 8][@length 13];
    }[@@deriving hardcaml]
  end

  module O = struct
    type 'a t = {
      output : 'a[@bits 8];
    }[@@deriving hardcaml]
  end

  let f i = { O.output = reduce (fun a b -> mux2 (a >: b) a b) i.I.inputs }

end

let test () = 
  let open Solution in
  let module C = Checksim.Make(B)(I)(O) in
  let open I in
  let open O in

  let i,o,_,reset,cycle,waves = C.make Solution.f (fun i -> { output = Maxn.maxn i.inputs }) in
  
  for j=0 to 9 do
    List.iter (fun i -> i := B.srand 8) i.inputs;
    cycle ();
  done;
  waves ()

let maxn_tutorial = "maxn", test


