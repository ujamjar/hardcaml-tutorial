open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution1(Bits : sig val bits : int end) = struct

  module I = struct
    type 'a t = 
      {
        a : 'a[@bits Bits.bits];
        b : 'a[@bits Bits.bits];
      }[@@deriving hardcaml]
  end
  module O = struct
    type 'a t = 
      {
        c : 'a[@bits Bits.bits];
      }[@@deriving hardcaml]
  end

  let f i = { O.c = i.I.a +: i.I.b }

end

let test1 bits = 
  let module X = Solution1(struct let bits = bits end) in
  let module C = Checksim.Make(B)(X.I)(X.O) in
  let open X.I in
  let open X.O in

  let i,o,_,reset,cycle,waves = C.make X.f (fun i -> {c=Adder.adder i.a i.b}) in

  for j=0 to 9 do
    i.a := B.srand bits;
    i.b := B.srand bits;
    cycle ()
  done;
  waves ()

let adder_tutorial = "adder", (fun () -> test1 2; test1 8)

module Solution2(Bits : sig 
    val bits_a : int 
    val bits_b : int 
end) = struct

  module I = struct
    type 'a t = 
      {
        a : 'a[@bits Bits.bits_a];
        b : 'a[@bits Bits.bits_b];
      }[@@deriving hardcaml]
  end
  module O = struct
    type 'a t = 
      {
        c : 'a[@bits (1 + max Bits.bits_a Bits.bits_b)];
      }[@@deriving hardcaml]
  end

  let f i = { O.c = Signed.(to_signal I.(of_signal i.a +: of_signal i.b)) }

end

let test2 bits_a bits_b = 
  let module X = Solution2(struct let bits_a = bits_a let bits_b = bits_b end) in
  let module C = Checksim.Make(B)(X.I)(X.O) in
  let open X.I in
  let open X.O in

  let i,o,_,reset,cycle,waves = C.make X.f (fun i -> {c=Adder.signed_adder i.a i.b}) in

  reset ();
  for j=0 to 9 do
    i.a := B.srand bits_a;
    i.b := B.srand bits_b;
    cycle ()
  done;
  waves ()

let signed_adder_tutorial = "signed_adder", (fun () -> test2 2 3; test2 8 4)

