open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution = struct

  open Counter
  open I
  open O

  let f i = 
    let total = 
      Seq.(reg_fb ~e:i.incr ~w:8 
        (fun d -> 
          let d = Uop.(d +: i.amount) in
          mux2 (msb d) (zero 8) (lsbs d))) 
    in
    { total }

end

let test () = 
  let module C = Checksim.Make(B)(Counter.I)(Counter.O) in
  let open Counter.I in
  let open Counter.O in

  let i,o,_,reset,cycle,waves = C.make Solution.f Counter.counter in

  reset ();
  for j=0 to 99 do
    i.incr := B.srand 1;
    i.amount := B.srand 4;
    cycle ()
  done;
  waves ()

let counter_tutorial = "counter", (fun () -> test ())


