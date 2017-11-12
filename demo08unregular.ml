#use "topfind";;
#require "visitors.ppx";;
#require "visitors.runtime";;

type 'a seq =
    | Nil
    | Zero of ('a * 'a ) seq
    | One of 'a * ('a * 'a) seq
[@@deriving visitors { polymorphic = true; variety = "iter"; irregular = true }]
