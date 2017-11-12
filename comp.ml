type 'a mylist = Nil | Cons of 'a  * 'a mylist
[@@deriving visitors  { variety = "map"; polymorphic = false }]

type 'a t =
| A
| B  of 'a mylist
(*
[@@deriving visitors  { variety = "map"; polymorphic = true
                      ; concrete = true; data = false }]
*)
[@@deriving visitors  { variety = "map"; polymorphic = false }]
