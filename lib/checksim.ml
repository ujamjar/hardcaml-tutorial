open HardCaml

let show_waves = ref false

module Make(B : Comb.S)(I : Interface.S)(O : Interface.S) = struct

  module C = Cyclesim.Api
  module W = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
  module Ws = HardCamlWaveTerm.Sim.Make(B)(W)
  module Widget = HardCamlWaveTerm.Widget.Make(B)(W)

  let fixup_outputs f i = 
    let o = f i in
    O.map2 (fun (n,b) x -> if x = Signal.Types.Signal_empty then Signal.Comb.zero b else x) O.t o

  let make fs fp = 

    (* create the problem and the solution *)
    let module S = Interface.Sim(B)(I)(O) in
    let _,sim1,i1,o1,n1 = S.make "solution" fs in
    let _,sim2,i2,o2,n2 = S.make "problem" (fixup_outputs fp) in

    let sim1, waves1 = Ws.wrap sim1 in
    let sim2, waves2 = Ws.wrap sim2 in

    let reset () = 
      C.reset sim1;
      C.reset sim2;
    in

    (* cycle - copy inputs, check outputs *)
    let o = O.map2 (fun o1 o2 -> o1,o2) o1 o2 in
    let cycle_no = ref 0 in
    let cycle () = 
      ignore @@ I.map2 (fun i1 i2 -> i2 := !i1) i1 i2;
      C.cycle sim1;
      C.cycle sim2;
      ignore @@ O.map2 (fun (n,_) (o1,o2) ->
        if o1 <> o2 then begin
          Printf.printf "[%i] '%s' \"%s\" \"%s\"\n" 
            !cycle_no n (B.to_bstr !o1) (B.to_bstr !o2)
        end) O.t o;
        incr cycle_no
    in

    let waves () = 
      if !show_waves then begin
        let waveform = new Widget.waveform () in
        let waves = Array.concat [ waves1; waves2 ] in
        let waves = W.{ cfg={default with wave_width=2}; waves } in
        waveform#set_waves waves;
        Lwt_main.run @@ Widget.run_widget waveform
      end
    in

    i1, o1, n1, reset, cycle, waves


end
