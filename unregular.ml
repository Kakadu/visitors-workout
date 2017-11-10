(*
# #require "visitors.ppx";;
# #require "visitors.runtime";;
*)
type 'a seq =
| Nil
| Zero of ('a * 'a ) seq
| One of 'a * ( 'a * 'a ) seq
[@@deriving visitors { polymorphic = true; variety = "iter"; irregular = true }]

(* poluymorphic: bool
If true, type variables are handled by virtual visitor methods,
and generated methods are monomorphic (§2.12.1); if false, type
variables are handled by visitor functions, and generated methods
are polymorphic (§2.12.2). This is an optional parameter, whose
default value is false.

Короче, visit_'a можно сделать методом, а можно везде передавать
*)
