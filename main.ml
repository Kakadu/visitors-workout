(* type binop = Mul | Add
[@@deriving visitors { variety = "map"; polymorphic = true; concrete = true ; data = false}] *)

(* type 'info expr_node =
| EConst of int
| EAdd of 'info expr * 'info expr *)
(* type 'info expr_node = EConst of int | EAdd of 'info expr * 'info expr
and 'info expr =
{ info : 'info ; node : 'info expr_node }
  [@@deriving visitors { variety = "map" ; polymorphic = true; concrete = true ; data = false}]
;;

class type [ 'self ] iter = object
  method visit_EAdd   : 'monomorphic . 'env -> expr -> expr -> unit
  method visit_EConst : 'monomorphic . 'env -> int -> unit
  method visit_expr   : 'monomorphic . 'env -> expr -> unit
end *)

(* type expr =
| EConst of int
| EAdd of expr * expr
[@@deriving visitors { variety = " iter " }]

class virtual [ 'self ] iter = object ( self : 'self )
  inherit [ _ ] VisitorsRuntime.iter
  method visit_EConst env c0 =
    let r0 = self # visit_int env c0 in
    ()
  method visit_EAdd env c0 c1 =
    let r0 = self # visit_expr env c0 in
    let r1 = self # visit_expr env c1 in
    ()
  method visit_expr env this =
    match this with
    | EConst c0        ->   self#visit_EConst env c0
    | EAdd ( c0 , c1 ) ->   self#visit_EAdd env c0 c1
end *)

class virtual [ 'self ] reduce = object ( self : 'self )
  method private visit_option : 'a . ('env -> 'a -> 'z ) -> 'env -> 'a option -> 'z  = fun f env ox ->
    match ox with None -> self # zero | Some x -> f env x  (** 1 **)
  method private virtual zero : 'z
end
class [ 'self ] map = object ( _ : 'self )
  method private visit_option : 'a 'b . ( 'env -> 'a -> 'b ) -> 'env -> 'a option -> 'b option = fun f env ox ->
    match ox with None -> None | Some x -> Some ( f env x )    (** 2 **)
end
class virtual [ 'self ] fold = object ( self : 'self )
  (* There is a similarity between 1 and 2 so we define visit_optin in `fold` like this *)
  method private visit_option : 'a . ( 'env -> 'a -> 'r ) -> 'env -> 'a option -> 's = fun f env ox ->
    (* We assign the most general type that is polym. over `'a` abd can't be polymorphic  over `'r` and
      over `'s` because they appear in another methods. They will beimplicitly quantified on level of class *)
    match ox with
    | None  -> self # build_None env
    | Some x -> self # build_Some env ( f env x )
  method private virtual build_None : 'env -> 's
  method private virtual build_Some : 'env -> 'r -> 's
end

(* Now let's try to define map and reduce using fold *)

(* A successful definition of [ reduce ] in terms of [ fold ]. *)
(* 'r and 's are both instantiated as 'z *)
class virtual [ 'self ] reduce_from_fold = object ( self : 'self )
  inherit [ _ ] fold
  method private build_None _env = self # zero
  method private build_Some _env z = z
  method private virtual zero : 'z
end
(* An unsatisfactory definition of [ map ] in terms of [ fold ]. *)
class [ 'self ] map_from_fold = object ( _ : 'self )
  inherit [ _ ] fold
  method private build_None _env  = None
  method private build_Some _env x = Some x
end
(*
The type of not polymorphic enough class is
class [ 'self ] map_from_fold : object ( 'self )
  method private visit_option : ’a . ( 'env -> ’a -> ’b ) -> 'env -> ’a option -> ’b option
  method private build_None : 'env -> ’b option
  method private build_Some : 'env -> ’b -> ’b option
end
*)


(* The type of `visit_option` is not general enough. The types 'r and 's have kind * but should have
  kind * -> *
*)

(*
class [ 'self ] fold : object ( 'self )
  method private visit_option : ’a ’b . ('env -> ’a -> ’r [ 'b ]) -> 'env -> ’a option -> ’s [ 'b ]
  method private virtual build_None : ’b . 'env -> ’s [ 'b ]
  method private virtual build_Some : ’b . 'env -> ’r [ 'b ] -> ’s [ 'b ]
end

*)


(*
This suggests that higher kinds, type-level functions, and type-level β-reduction might be valuable
features, not just in functional programming languages, but also in an object-oriented programming
setting.
*)
