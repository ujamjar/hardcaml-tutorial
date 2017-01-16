open HardCaml.Signal
open HardCaml.Signal.Comb

module I = struct
  type 'a t = {
    incr : 'a[@bits 1];
    amount : 'a[@bits 4];
  }[@@deriving hardcaml]
end

module O = struct
  type 'a t = {
    total : 'a[@bits 8];
  }[@@deriving hardcaml]
end

module Seq = Make_seq(struct
  let reg_spec = HardCaml.Signal.Seq.r_sync
  let ram_spec = HardCaml.Signal.Seq.r_none
end)

(* increment 'total' by 'amount' whenever 'incr' is high.
   Whenever the total overflows, set it to 0.
   All values are unsigned. *)
let counter i = { O.total = empty }

