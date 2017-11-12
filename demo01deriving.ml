#use "topfind";;
#require "ppx_deriving.std";;
open Ppx_deriving;;

type ('a, 'b) alist = Cons of 'a * 'b option | Nil [@@deriving show, map] ;;
let xs = Cons (1, Some "asdf");;

let () = Format.fprintf Format.std_formatter "%a\n%!" 
           (pp_alist 
              (fun fmt -> Format.fprintf fmt "%d")
              (fun fmt -> Format.fprintf fmt "%s") )
           xs ;;

let () = Format.fprintf Format.std_formatter "%a\n%!" 
           (pp_alist 
              (fun fmt -> Format.fprintf fmt "%d")
              (fun fmt -> Format.fprintf fmt "%s") )
  @@ map_alist ((+)1) ((^)"!") xs ;;
