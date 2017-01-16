open HardCaml
open Signal.Comb
module B = Bits.Comb.IntbitsList

module Solution(X : sig
    val n : int
    val w : int
end) = struct

  module P = Prioritymux.Problem(X)

  open P.I
  open P.O


  let f i = 
    let rec f d' = function
      | [],[] -> d'
      | s::st,d::dt -> f (mux2 s d d') (st,dt)
      | _ -> failwith "unexpected error"
    in
    { q = f (zero X.w) (bits i.sel, List.rev i.d) }


end

let test n w = 
  let module S = Solution(struct
    let n = n
    let w = w
  end) in

  let module C = Checksim.Make(B)(S.P.I)(S.P.O) in
  let i,o,_,reset,cycle,waves = C.make S.f S.P.prioritymux in

  let open S.P.I in
  for j=0 to 9 do
    i.sel := B.srand n;
    List.iter (fun d -> d := B.srand w) i.d;
    cycle ()
  done;
  waves ()

let prioritymux_tutorial = "prioritymux", (fun () -> test 2 6; test 4 8; test 6 6)

