open HardCaml
open Signal
open Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  open Vendingmachine
  open I
  open O

  let f i = 
    let is, switch, next = Statemachine.statemachine Seq.r_sync vdd 
        [Sidle; S5; S10; S15; Svalid] 
    in
    let open Guarded in
    let () = compile [
        switch [
          Sidle, [
            g_when i.nickel [ next S5 ];
            g_when i.dime [ next S10 ];
          ];
          S5, [
            g_when i.nickel [ next S10 ];
            g_when i.dime [ next S15 ];
          ];
          S10, [
            g_when i.nickel [ next S15 ];
            g_when i.dime [ next Svalid ];
          ];
          S15, [
            g_when i.nickel [ next Svalid ];
            g_when i.dime [ next Svalid ];
          ];
          Svalid, [
            next Sidle;
          ];
        ]
    ] in
    { O.valid = is Svalid }


end

let test () = 

  let module C = Checksim.Make(B)(Vendingmachine.I)(Vendingmachine.O) in
  let i,o,_,reset,cycle,waves = C.make Solution.f Vendingmachine.vendingmachine in

  let open Vendingmachine.I in
  for j=0 to 9 do
    let b = B.srand 1 in
    i.nickel := b;
    i.dime := B.(~: b);
    cycle ()
  done;
  waves ()

let vendingmachine_tutorial = "vendingmachine", (fun () -> test ())


