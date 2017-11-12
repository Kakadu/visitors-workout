#use "topfind";;

(* class virtual int_cell = object ( self )
   val mutable x = 0
   method get = x
   method set y = x <- self # check y
   method virtual check : _
   end
*)

class virtual [ 'a ] int_cell = object ( self )
  val mutable x = 0
  method get = x
  method set y = x <- self # check y
  method virtual check : 'a -> _
end

(*
class virtual [ 'a ] cell ( init ) = object ( self )
val mutable x = init
method get = x
method set y = x <- self # check y
method virtual check : 'a -> _
end
*)
class virtual [ 'a, 'b ] cell ( init ) = object ( self )
  val mutable x = init
  method get = x
  method set y = x <- self # check y
  method virtual check : 'a -> 'b
end

class virtual [ 'check ] cell ( init ) = object ( self )
  val mutable x = init
  method get = x
  method set y = x <- self # check y
  method virtual check : 'check
end
(* ****************************************************** *)
type expr =
    | EConst of int
    | EAdd of expr * expr
[@@deriving visitors { variety = "map" }]

class type virtual [ 'self ] iter = object ( 'self )
  method visit_EAdd:  'env -> expr -> expr -> unit
  method visit_EConst:  'env -> int -> unit
  method visit_expr: (*'monomorphic . *) 'env -> expr -> unit
end;;



class [ 'self ] c = object (_ : 'self)
  (* methods itself is mopnomorphic *)
  method identity (x : 'a) : 'a = x
end
(* But object is polymorphic *)
let b : bool = new c#identity true
let i : int  = new c#identity 0
