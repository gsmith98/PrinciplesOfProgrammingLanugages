val z : int list
val squared : int -> int
val fib : int -> int
val funny_add1 : int -> int
val add3 : int -> int
val mixemup : int -> int
val tuple : int * string * float
val mypair : float * float
val getSecond : 'a * 'b -> 'b
val s : float
val getHead : int list -> int
val cadd : int * int -> int
val rev : 'a list -> 'a list
val y : int
val shad : int -> int
val copy : 'a list -> 'a list
val result : int list
val copyodd : 'a list -> 'a list
val copyeven : 'a list -> 'a list
val copyoddonly : 'a list -> 'a list
val timestenlist : int list -> int list
val appendgobblelist : string list -> string list
val map : ('a -> 'b) -> 'a list -> 'b list
val middle : string list -> string list
val timesten : int -> int
val plus3 : int -> int
val times2 : int -> int
val times2plus3 : int -> int
val compose : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b
val add1 : int -> int
val id : 'a -> 'a
val addC : int -> int -> int
val addNC : int * int -> int
val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
val newaddNC : int * int -> int
val newaddC : int -> int -> int
val noop1 : int -> int -> int
val noop2 : int * int -> int
val add : int -> int -> int
type intpair = int * int
val compose_funs : ('a -> 'a) list -> 'a -> 'a
val composeexample : int -> int
val toUpperChar : char -> char
val toUpperCase : char list -> char list
exception Failure
val nth : 'a list -> int -> 'a
val partition : ('a -> bool) -> 'a list -> 'a list * 'a list
val isPositive : int -> bool
val contains : 'a -> 'a list -> bool
val diff : 'a list -> 'a list -> 'a list
type mynumber = Fixed of int | Floating of float
val pullout : mynumber -> int
val add_num : mynumber -> mynumber -> mynumber
type sign = Positive | Negative | Zero
val sign_int : int -> sign
type complex = CZero | Nonzero of float * float
val com : complex
type itree = ILeaf | INode of int * itree * itree
type 'a btree = Leaf | Node of 'a * 'a btree * 'a btree
val whack : string btree
val bt : string btree
val bt2 : string btree
type 'a mylist = MtList | ColonColon of 'a * 'a mylist
val mylisteg : int mylist
val double_list_elts : int mylist -> int mylist
val add_gobble : string btree -> string btree
val gobtree : string btree
val lookup : 'a -> 'a btree -> bool
val insert : 'a -> 'a btree -> 'a btree
val goobt : string btree
val gooobt : string btree
type ratio = { num : int; denom : int; }
val q : ratio
val rattoint : ratio -> int
val add_ratio : ratio -> ratio -> ratio
type scale = { num : int; coeff : float; }
type mutable_point = { mutable x : float; mutable y : float; }
val translate : mutable_point -> float -> float -> unit
val mypoint : mutable_point
type mtree = MLeaf | MNode of int * mtree ref * mtree ref
val x : int ref
val arrhi : string array
val arr : int array
exception Foo
exception Bar
exception Goo of string
val f : 'a -> 'b
val g : unit -> unit
module FSet :
  sig
    exception NotFound
    type 'a set = 'a list
    val emptyset : 'a set
    val add : 'a -> 'a set -> 'a set
    val remove : 'a -> 'a set -> 'a set
    val contains : 'a -> 'a set -> bool
  end
val mySet : int FSet.set
val myNextSet : int FSet.set
module type GROWINGSET =
  sig
    exception NotFound
    type 'a set = 'a list
    val emptyset : 'a set
    val add : 'a -> 'a set -> 'a set
    val contains : 'a -> 'a set -> bool
  end
module GrowingSet : GROWINGSET
module type HIDDENSET =
  sig
    type 'a set
    val emptyset : 'a set
    val add : 'a -> 'a set -> 'a set
    val remove : 'a -> 'a set -> 'a set
    val contains : 'a -> 'a set -> bool
  end
module HiddenSet : HIDDENSET
module HFSet :
  sig
    type 'a set
    val emptyset : 'a set
    val add : 'a -> 'a set -> 'a set
    val remove : 'a -> 'a set -> 'a set
    val contains : 'a -> 'a set -> bool
  end
val hs : int HFSet.set
module FSett : sig  end
module Main : sig  end
type comparison = Less | Equal | Greater
module type ORDERED_TYPE = sig type t val compare : t -> t -> comparison end
module FSetFunctor :
  functor (Elt : ORDERED_TYPE) ->
    sig
      type element = Elt.t
      type set = element list
      val empty : 'a list
      val add : Elt.t -> Elt.t list -> Elt.t list
      val contains : Elt.t -> Elt.t list -> bool
    end
module OrderedInt : sig type t = int val compare : 'a -> 'a -> comparison end
module OrderedIntSet :
  sig
    type element = OrderedInt.t
    type set = element list
    val empty : 'a list
    val add : OrderedInt.t -> OrderedInt.t list -> OrderedInt.t list
    val contains : OrderedInt.t -> OrderedInt.t list -> bool
  end
val myOrderedIntSet : OrderedInt.t list
module OrderedString :
  sig type t = string val compare : 'a -> 'a -> comparison end
module OrderedStringSet :
  sig
    type element = OrderedString.t
    type set = element list
    val empty : 'a list
    val add : OrderedString.t -> OrderedString.t list -> OrderedString.t list
    val contains : OrderedString.t -> OrderedString.t list -> bool
  end
val myOrderedStringSet : OrderedString.t list
module type SETFUNCTOR =
  functor (Elt : ORDERED_TYPE) ->
    sig
      type element = Elt.t
      type set
      val empty : set
      val add : element -> set -> set
      val contains : element -> set -> bool
    end
module AbstractSet : SETFUNCTOR
module AbstractIntSet :
  sig
    type element = OrderedInt.t
    type set = AbstractSet(OrderedInt).set
    val empty : set
    val add : element -> set -> set
    val contains : element -> set -> bool
  end
