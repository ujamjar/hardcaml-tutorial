open HardCaml.Signal
open HardCaml.Signal.Comb

module I = struct
  type 'a t = {
    input : 'a[@bits 1];
  }[@@deriving hardcaml]
end

module O = struct
  type 'a t = {
    output : 'a[@bits 8];
  }[@@deriving hardcaml]
end

module Seq = Make_seq(struct
  let reg_spec = HardCaml.Signal.Seq.r_sync
  let ram_spec = HardCaml.Signal.Seq.r_none
end)

(* increment output on each clock whenever input is high *)
let accumulator i = 
  { O.output = empty }

