# hardcaml-tutorial

This is a collection of simple tutorial examples ported from the
the [Chisel tutorial repo](https://github.com/ucb-bar/chisel-tutorial).

They are structured into 2 parts.  A basic skeleton and 
short description is provided for each design in the problems directory.
A working solution and testbench is provided in the solutions directory.

The aim is to provide an implementation for the problem and test it
against the provided solution.

Running `make` will build an application, called `tutorial.native`, that 
can be run against each tutorial example.  The testbench will instantiate
the problem and solution implementations and run them together.
Both designs are supplied with the same inputs and we expect the circuit
outputs to match exactly.  Any mismatch will be printed.

To aid debugging, pass the `-waves` options to display a waveform showing
both circuits.

# Examples

In rough order of complexity

* *combinational circuits* adder, max2, maxn, table, prioritymux
* *sequential circuits* accumulator, counter, lfsr, gcd, dynamic\_memory\_search, vendingmachine

# Interfaces and sequential logic

A few examples are just simple functions that need to be implemented.  Most,
however, declare interfaces using ppx\_deriving\_hardcaml.
In these examples the problem function takes a record of type `signal I.t`
and returns a record of type `signal O.t`.  The records list the input
and output interfaces of the circuit.

Where sequential logic is needed, a module is instantiated with type
[`HardCaml.Signal.Seq`](https://github.com/ujamjar/hardcaml/blob/a1c6ebf5bc7936445921449fe3df541e3337f0e7/src/signal.mli#L440).

```
module Seq = Make_seq(struct
  let reg_spec = HardCaml.Signal.Seq.r_sync
  let ram_spec = HardCaml.Signal.Seq.r_none
end)
```

The testbenches generally assume you are using the register functions 
defined there.

# References

The APIs required to implement all the examples are in the following two
files.

* [comb.mli](https://github.com/ujamjar/hardcaml/blob/master/src/comb.mli)
* [signal.mli](https://github.com/ujamjar/hardcaml/blob/master/src/signal.mli)

# License

Provided under the original license.

```
Copyright (c) 2014 - 2016 The Regents of the University of
California (Regents). All Rights Reserved.  Redistribution and use in
source and binary forms, with or without modification, are permitted
provided that the following conditions are met:
   * Redistributions of source code must retain the above
     copyright notice, this list of conditions and the following
     two paragraphs of disclaimer.
   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     two paragraphs of disclaimer in the documentation and/or other materials
     provided with the distribution.
   * Neither the name of the Regents nor the names of its contributors
     may be used to endorse or promote products derived from this
     software without specific prior written permission.
IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
REGENTS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF
ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION
TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
MODIFICATIONS.
```

