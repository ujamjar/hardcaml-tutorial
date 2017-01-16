open HardCaml.Signal
open Comb

module I = struct
  type 'a t = {
    nickel : 'a[@bits 1];
    dime : 'a[@bits 1];
  }[@@deriving hardcaml]
end

module O = struct
  type 'a t = {
    valid : 'a[@bits 1];
  }[@@deriving hardcaml]
end

(* Implement a vending machine using the Guarded module.

    A 'nickel' is a 5 cent coin.
    A 'dime' is a 10 cent coin.

   A statemachine should be written which tracks how much has been
   inserted into the vending machine until the total reaches 
   20 cents or more where it should be in the Svalid state.  The 
   vending machine should return to Sidle from Svalid immediately.

   For the 1 cycle the machine is in state Svalid the 'valid' output
   signal should be high.

   Note; only one of 'nickel' and 'dime' will be high in any given cycle
 *)
type states = Sidle | S5 | S10 | S15 | Svalid

let vendingmachine i = 
  let is, switch, next = Statemachine.statemachine Seq.r_sync vdd 
    [Sidle; S5; S10; S15; Svalid] 
  in
  { O.valid = empty }

