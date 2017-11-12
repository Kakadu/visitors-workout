type 'info expr_node =
| EConst of int
| EAdd of 'info expr * 'info expr
and 'info expr =
{ info : 'info ; node : 'info expr_node }
[@@deriving visitors  { variety = "map"; polymorphic = true
                      ; concrete = true; data = false }]

(* Polymorphic genration for every visitor except fold and fold2
  { data = false } inlines visit_EConst & _EAdd (it's shorter )
  { concrete = true } because map class has no virtual methods
     and we can make it concrete.
*)

let v = new map

let strip : _ expr -> unit expr =
  let visit_'info _env _info = () in
  fun e ->
    v # visit_expr visit_'info () e

let number : _ expr -> int expr =
  let visit_'info count _info =
    let c = ! count in count := c + 1; c in
  fun e ->
    let count = ref 0 in
    v # visit_expr visit_'info count e
