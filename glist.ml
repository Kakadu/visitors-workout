type ('a, 'b) glist = Nil | Cons of 'a * 'b
[@@deriving visitors  { variety = "map"; polymorphic = true
                      ; concrete = true; data = false }]

(*
type 'a list = ('a, 'a list) glist
[@@deriving visitors  { variety = "map"; polymorphic = true
                      ; concrete = true; data = false }]
*)
