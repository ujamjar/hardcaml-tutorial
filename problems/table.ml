open HardCaml.Signal.Comb
module B = HardCaml.Bits.Comb.IntbitsList

(* construct a table to implement the given function 'fn'. 
   'fn' takes 2 arguments of width a_bits and b_bits.  You can 
   assume a_bits and b_bits < 8.

    val fn : B.t -> B.t -> B.t

     note the function `val constibl : B.t -> signal`

   Should return a function which takes signals a and b and looks
   up the table.
 *)
let tablegen a_bits b_bits fn = 
  let table = empty in
  (fun a b -> empty)


