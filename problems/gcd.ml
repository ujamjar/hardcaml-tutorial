open HardCaml.Signal
open Comb

module I = struct
  type 'a t = {
    start : 'a[@bits 1];
    a : 'a[@bits 6];
    b : 'a[@bits 6];
  }[@@deriving hardcaml]
end

module O = struct
  type 'a t = {
    gcd : 'a[@bits 6];
    ready : 'a[@bits 1];
  }[@@deriving hardcaml]
end

module Seq = Make_seq(struct
  let reg_spec = HardCaml.Signal.Seq.r_sync
  let ram_spec = HardCaml.Signal.Seq.r_none
end)

(* calculate the greated common divisor of 'a' and 'b'.
   When 'start' is high 'a' and 'b' should be copied into internal
   registers.

   Then compute on each clock cycle

    if (a > b) 
      a = b
      b = a
    else
      b = b - a

   The result is valid when b == 0 and should be indicated by the 
   'ready' signal going high.  The result, given by 'a', is returned
   through 'gcd'.
 *)
let gcd i = { O.gcd = empty; ready = empty }

