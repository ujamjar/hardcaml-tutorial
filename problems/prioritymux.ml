open HardCaml.Signal.Comb

module Problem(X : sig
    val n : int
    val w : int
end) = struct

  module I = struct
    type 'a t = {
      sel : 'a[@bits X.n];
      d : 'a list[@bits X.w][@length X.n];
    }[@@deriving hardcaml]
  end

  module O = struct
    type 'a t = {
      q : 'a[@bits X.w];
    }[@@deriving hardcaml]
  end

  (* build a priority multiplexor using mux2s.
     
     The nth bit of 'sel' corresponds the nth element of the list 'd'.
     This function should return the first element of 'd' for which the
     corresponding bit in 'sel' is high. 
  
     If no bit in 'sel' is set return 0.
  *)
  let prioritymux i = 
    { O.q = empty }

end

