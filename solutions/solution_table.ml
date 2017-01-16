open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution(X : sig
    val a_bits : int
    val b_bits : int
    val c_bits : int
end) = struct

  module I = struct
    type 'a t = {
      a : 'a[@bits X.a_bits];
      b : 'a[@bits X.b_bits];
    }[@@deriving hardcaml]
  end

  module O = struct
    type 'a t = {
      c : 'a[@bits X.c_bits];
    }[@@deriving hardcaml]
  end

  let f fn = 
    let table = 
      List.concat @@ Array.to_list @@ Array.init (1 lsl X.a_bits) 
        (fun a -> 
           Array.to_list @@ Array.init (1 lsl X.b_bits) 
             (fun b -> 
                constibl (fn (B.consti X.a_bits a) (B.consti X.b_bits b))))
    in
    (fun i -> { O.c = mux (i.I.a @: i.I.b) table })


end

let test a_bits b_bits c_bits fn = 
  let module S = Solution(struct
    let a_bits = a_bits
    let b_bits = b_bits
    let c_bits = c_bits
  end) in
  let module C = Checksim.Make(B)(S.I)(S.O) in
  let open S.I in
  let open S.O in

  let i,o,_,reset,cycle,waves = C.make (S.f fn) 
    (fun i -> { c = Table.tablegen a_bits b_bits fn i.a i.b }) 
  in
  
  for j=0 to 9 do
    i.a := B.srand a_bits;
    i.b := B.srand b_bits;
    cycle ();
  done;
  waves ()

let table_tutorial = 
  "table", (fun () -> 
             test 5 4 6 B.Uop.(+:);
             test 3 4 7 B.Sop.( *: ))


