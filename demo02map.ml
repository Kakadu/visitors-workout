type 'a logic = Var of int | Value of 'a [@@deriving map];;

type 'a lst = Nil | Cons of 'a  * ('a lst) logic [@@deriving map];;
