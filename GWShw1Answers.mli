val pair : 'a -> 'b -> 'a * 'b
val zip : 'a list -> 'b list -> ('a * 'b) list
val zipWith : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
val split : int -> 'a list -> 'a list * 'a list
val sum : int list -> int
val reduce : ('a -> 'a -> 'a) -> 'a list -> 'a
val dot_product : int list -> int list -> int
val g_dot_product :
  ('a -> 'a -> 'a) -> ('b -> 'c -> 'a) -> 'b list -> 'c list -> 'a
val dimensions : 'a list list -> int * int
val chunk : int -> 'a list -> 'a list list
val transpose : 'a list list -> 'a list list
val identity_matrix : int -> int list list
val g_identity_matrix : 'a -> 'a -> int -> 'a list list
val matrix_multiply : int list list -> int list list -> int list list
val g_matrix_multiply :
  ('a -> 'a -> 'a) ->
  ('b -> 'c -> 'a) -> 'b list list -> 'c list list -> 'a list list
val nth : 'a list -> int -> 'a
val fetch_column : 'a list list -> int -> 'a list
val fetch_grid : 'a list list -> int -> int -> int -> int -> 'a list
val verify_list : int list -> bool
val verify_grid : int list list -> bool
