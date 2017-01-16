open HardCaml.Signal.Comb

(* Return the sum of a and b. 
   a and b can be assumed to be the same width.
   The result should also be the same width. *)
let adder a b = 
  assert (width a = width b);
  empty

(* Return the sum of a and b using signed arithmetic.
   a and b may be different widths.
   The result should be 1 bit larger then the widest of a and b *)
let signed_adder a b = empty

