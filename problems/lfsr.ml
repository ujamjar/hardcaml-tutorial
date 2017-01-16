open HardCaml.Signal
open HardCaml.Signal.Comb

module Seq = Make_seq(struct
  let reg_spec = HardCaml.Signal.Seq.r_sync
  let ram_spec = HardCaml.Signal.Seq.r_none
end)

(* Returns a 16 bit Fibonacci LFSR.
   Updates only when inc is high.
   The update step xors the values in the vector at the given tap positions,
   shifts the new value in at the msb.  The initial value of the LFSR is 1. 

   Hint: you need to set both the ~c and ~cv arguments to the register.
*)
let taps = [0;2;3;5]

let lfsr16 clr inc = 
  empty

