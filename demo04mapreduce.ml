type 'info expr_node =
| EConst of int
| EAdd of 'info expr * 'info expr
and 'info expr =
{ info : 'info ; node : 'info expr_node }
[@@deriving visitors { variety = "mapreduce" }]

let annotate ( e : _ expr ) : int expr =
  let v = object
    inherit [ _ ] mapreduce as super
    inherit [ _ ] VisitorsRuntime.addition_monoid
    method! visit_expr env { info = _ ; node } =
      let node , size = super # visit_expr_node env node in
      let size = size + 1 in
      { info = size ; node } , size
    method visit_'info _env _info =
      assert false (* never called *)
  end in
  let e, _ = v # visit_expr () e in
  e
