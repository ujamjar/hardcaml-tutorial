open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  open Gcd
  open I
  open O

  let f i = 
    let wx, wy = wire 6 -- "wx", wire 6 -- "wy" in
    let y_is_0 = wy ==:. 0 in
    let x_gt_y = wx >: wy in
    let x = Seq.reg ~e:vdd 
      (mux2 i.start i.a
         (mux2 y_is_0 wx
            (mux2 x_gt_y wy wx)))
    in
    let y = Seq.reg ~e:vdd
      (mux2 i.start i.b
         (mux2 y_is_0 wy
            (mux2 x_gt_y wx (wy -: wx))))
    in
    let () = wx <== x; wy <== y in
    { O.gcd = x; ready = y_is_0 }

end

let test () = 
  let module C = Checksim.Make(B)(Gcd.I)(Gcd.O) in
  let i,o,n,reset,cycle,waves = C.make Solution.f Gcd.gcd in

  let open Gcd.I in
  let open Gcd.O in
  for j=0 to 9 do
    let rec xrand n = (* zero is bad! *)
      let r = B.srand n in
      if B.to_int r = 0 then xrand n else r
    in
    i.start := B.vdd;
    i.a := xrand 6;
    i.b := xrand 6;
    cycle ();
    i.start := B.gnd;
    while B.to_int !(n.ready) = 0 do
      cycle ();
    done;
  done;
  cycle ();
  waves ()

let gcd_tutorial = "gcd", test


