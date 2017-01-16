open HardCaml.Signal
open HardCaml.Signal.Comb

let n, w = 4, 8

module I = struct
  type 'a t = {
    write : 'a[@bits 1];
    addr : 'a[@bits n];
    data : 'a[@bits w];
    start : 'a[@bits 1];
  }[@@deriving hardcaml]
end

module O = struct
  type 'a t = {
    target : 'a[@bits n];
    done_ : 'a[@bits 1];
  }[@@deriving hardcaml]
end

module Seq = Make_seq(struct
  let reg_spec = HardCaml.Signal.Seq.r_sync
  let ram_spec = HardCaml.Signal.Seq.r_none
end)

open I
open O

(* Search a RAM for matching data and output the index. 
  
   The module contains a small internal RAM which should be written
   to when 'write' is high at 'addr' with 'data'.  'target' should also 
   be set to 0 when writing to the ram.

   When 'start' is set high, 'done_' should go low and the RAM should 
   be read sequentially from address 0 until the 'data' matches the 
   output of the RAM.  At this point 'done_' is set high and target
   will read the address at which the data matched. *)
let search i =
  let read = wire n in
  let q = Seq.memory (1 lsl n) ~we:i.write ~wa:i.addr ~d:i.data ~ra:read in

  let done_ = empty in
  let target = empty in

  { target; done_ }


