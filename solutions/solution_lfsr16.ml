open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  module I = struct
    type 'a t = {
      clr : 'a[@bits 1];
      inc : 'a[@bits 1];
    }[@@deriving hardcaml]
  end

  module O = struct
    type 'a t = {
      lfsr : 'a[@bits 16];
    }[@@deriving hardcaml]
  end

  module Seq = Signal.Make_seq(struct
    let reg_spec = HardCaml.Signal.Seq.r_sync
    let ram_spec = HardCaml.Signal.Seq.r_none
  end)

  let f i =
    { O.lfsr = 
        Seq.reg_fb ~c:i.I.clr ~cv:(one 16) ~e:i.I.inc ~w:16
          (fun d -> 
             let taps = List.map (fun tap -> bit d tap) Lfsr.taps in
             let tap = reduce (^:) taps in
             tap @: select d 15 1) 
    }

end

let test () = 
  let open Solution in
  let module C = Checksim.Make(B)(I)(O) in
  let open I in
  let open O in

  let i,o,_,reset,cycle,waves = C.make Solution.f 
    (fun i -> { lfsr = Lfsr.lfsr16 i.clr i.inc }) in

  i.clr := B.vdd;
  cycle ();
  i.clr := B.gnd;
  for j=0 to 9 do
    i.inc := B.srand 1;
    cycle ();
  done;
  waves ()


let lfsr16_tutorial = "lfsr16", test

