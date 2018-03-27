(*
  600.426 - Programming Languages
  JHU Spring 2015
  Homework 2

  In this source file, you will find a number of comments containing the text
  "ANSWER".  Each of these comments indicates a portion of the source code you
  must fill in yourself.  You are welcome to include other functions for use in
  your answers.  Read the instructions for each problem and supply a segment of
  code which accomplishes the indicated task.  For your convenience, a number of
  test expressions are provided for each problem as well as a description of
  their expected values.

  In this assignment, you are permitted to complete the listed tasks using any
  of the OCaml modules/functions.  However you are still required to avoid the use of
  mutation unless explicitly specified in the question.

  For any part of the assignment, you may use List, String, Set (though I
  discourage it), Map, and any other data structure which does not rely on
  mutation and is not already a heap data structure.
  
  Since they rely on mutation, you may not use Array (or related modules),
  Hashtbl, Buffer, or refs except for the last question.
  
  For the heap question, you may not use a builtin heap (I don't actually believe
  the OCaml stdlib has one, but if you manage to find one, don't use it).
  
  For the stream question, you may not use Stream.
*)


(* -------------------------------------------------------------------------------------------------- *)
(* Section 1 : The Game of Types                                                                      *)
(* -------------------------------------------------------------------------------------------------- *)

(*
  1. For the next several problems, you will be asked to produce an expression which
     has a given type.  It does not matter what expression you provide as long as it
     has that type; there may be numerous (or even infinite) answers for each
     question.  Your answer may *not* produce a compiler warning.  You are *not*
     permitted to use explicit type annotations (such as "fun x:'a -> x").

     Exact type variable names do not count, but must be consistent. For
     example, "'a -> 'b -> 'b" and "'b -> 'a -> 'a" are considered the same,
     but "'a -> 'a -> 'b" is different from both of them. Also, "'_a" and "'a"
     are considered different.

     [20 Points]
*)

(* Give an expression which has the following type: int ref *)
let exp1 = ref 4;; (* ANSWER *)

(* Give an expression which has the following type: '_a -> unit

   HINT: You may want to refer to this section of Real World Ocaml:
         https://realworldocaml.org/v1/en/html/imperative-programming-1.html#side-effects-and-weak-polymorphism
*)
let exp2 = let holder = ref None in fun z -> holder := Some z;;

(* Give an expression which has the following type: unit -> 'a *)

let exp3 =  let holder = ref None in fun () -> match !holder with | Some q -> q | None -> failwith "empty" ;; (* ANSWER *)

(* Give an expression which has the following type: 'a list -> ('a -> 'b) -> 'b list *)

let exp4 = let rec map l f =
  match l with 
    []    -> []
  | hd::tl -> (f hd) :: map tl f 
	in map;; (* ANSWER *)

(* Give an expression which has the following type: 'a list -> 'b list -> ('a * 'b) list *)
let exp5 = let rec zip xs ys = 
	match xs, ys with 
		  _, [] -> []
		| [], _ -> []
		| xshead :: xstail, yshead :: ystail -> (xshead, yshead) :: zip xstail ystail
		in zip;; (* ANSWER *)

(* Give an expression which has the following type: (int -> 'a -> 'b) -> 'a list -> ('b * 'b) list *)
let exp6 = let rec doit f lst = 
	match lst with 
	| [] -> []
	| h :: t -> ((f 0 h), (f 1 h)) :: doit f t 
	in doit;; (* ANSWER *)

(* Give an expression which has the following type: 'a list -> ('a -> bool) -> 'a list * 'a list *)
let exp7 = 
	let first (x,y) = x in
	let second (x,y) = y in
	let rec trythis lst f =
	match lst with
	| [] -> ([],[])
	| h :: t -> if f h then  (h :: first(trythis t f), second(trythis t f)) else (first(trythis t f), h :: second(trythis t f))
	in trythis;; (* ANSWER *)

type ('a, 'b) foobar = Foo of 'a | Bar of 'b ;;


(* Give an expression which has the following type: 'a -> ('b, 'c) foobar *)
let exp8 =  let test a = match Foo a with | Bar b -> Foo b | _  ->failwith "failure" in test;; (* ANSWER *)

(*
  Give an expression which has the following type:
  ('a, 'b) foobar list -> ('a -> 'c) -> ('b -> 'c) -> 'c list
*)
let exp9 = let rec unfoobar lst foof barf = match lst with 
 | [] -> [] 
 | Foo foo :: t -> (foof foo) :: unfoobar t foof barf
 | Bar bar :: t -> (barf bar) :: unfoobar t foof barf
in unfoobar;; (* ANSWER *)

(* Give an expression which has the following type: 'a -> 'b *)
let exp10 = let rando a = match Foo a with | Bar b -> b | _ -> failwith "fails" in rando ;; (* ANSWER *)


(* -------------------------------------------------------------------------------------------------- *)
(* Section 2 : An ode to being lazy                                                                   *)
(* -------------------------------------------------------------------------------------------------- *)

(*
   [20 Points]
*)

(*
  OCaml is an eager language. So you cannot create infinite lists/sequences directly. However you can
	encode them fairly easily in the language.
	
	For the purpose of this exercise we will encode (potentially) infinite lists using the following type.
*)
type 'a sequence = Nil | Sequence of 'a * (unit -> 'a sequence);;

(* As a hint, here how you would write a an infinite sequence of zeroes *)
let rec zeroes = Sequence(0, function () -> zeroes);;

(* And a finite sequence 1, 2 *)
let one_and_two = Sequence(1, fun () -> Sequence(2, fun () -> Nil)) ;;


(*
  2a. Write a function to convert a sequence to a list. Of course if you try to evaluate this on an infinite
	    sequence, it will not finish. But we will assume sanity on the caller's part and ignore that issue
	
*)
let rec list_of_sequence s = match s with
	| Nil -> []
	| Sequence (h, tfunc) -> h :: list_of_sequence (tfunc ())  ;;

(*
# list_of_sequence one_and_two ;;
- : int list = [1; 2]
*)

(*
  2b. While it is nice to have these infinite sequences, it is often useful to "cut" them to a fixed size. Write
	    a function that cuts off a sequence after a fixed number of values. The return value is a finite sequence
	    of the same type.
			
			(Treat the given count 'n' as the maximum number of elements allowed in the output sequence. So if the input
			is a finite sequence and its length is less than the specified count, the output sequence can have less than
			'n' values)
	
*)
let rec cut_sequence n s = match n, s with
| 0, _ ->  Nil
| _, Nil -> Nil
| n, Sequence (h, tfunc) -> Sequence(h, fun () -> cut_sequence (n-1) (tfunc ()) );;

(*
# list_of_sequence (cut_sequence 5 zeroes) ;;
- : int list = [0; 0; 0; 0; 0]
*)


(*
  2c. You can also encode finite sequences directly using the above type. For this question encode the sequence
	    corresponding to an geometric progression given an initial value, the end value (inclusive) and the common
	    factor (the step size of the sequence)
	
*)	
let rec gp initv endv step = if initv > endv then Nil else Sequence(initv, fun () -> gp (initv*step) endv step);;

(*
# list_of_sequence (gp 1 12 3) ;;
- : int list = [1; 3; 9]
# list_of_sequence (gp 2 20 2)  ;;
- : int list = [2; 4; 8; 16]
*)

(*
  2d. Now write two infinite sequences: one of factorials, one of triangle numbers.
*)
let factorials = 
	let rec fact x = if x <= 1 then 1 else x * fact (x - 1) in
	let rec makefacts n = Sequence(fact n, fun () -> makefacts (n+1)) in
	makefacts 0;;

let triangles = 
	let rec tri x = if x <= 0 then 0 else x + tri (x - 1) in
	let rec maketris n = Sequence(tri n, fun () -> maketris (n+1)) in
	maketris 0;;

(*	
# list_of_sequence (cut_sequence 8 factorials) ;;
- : int list = [1; 1; 2; 6; 24; 120; 720; 5040]
# list_of_sequence (cut_sequence 10 triangles) ;;
- : int list = [0; 1; 3; 6; 10; 15; 21; 28; 36; 45]
*)
	
(*
  2e. Write a filter-map function which takes a function and a sequence as input
      and returns a new sequence where the values have been mapped using the input
      function and potentially dropped.

      Note that if the filter part always returns None and the input sequence is infinite,
      this function will not terminate. Ignore this issue.
*)

let rec filter_map_sequence : ('a -> 'b option) -> 'a sequence -> 'b sequence =
    fun f s -> match s with 
		| Nil -> Nil 
		| Sequence (h, funct) -> match (f h) with 
													| Some y -> Sequence( y, fun () -> filter_map_sequence f (funct ()) )
													| None -> filter_map_sequence f (funct ());;
			

(*
  2f. Write a map and filter functions (analogous to List.map and List.filter)
      using your implementation of filter_map_sequence.
*)

let rec map_sequence fn s =  filter_map_sequence (fun x -> Some (fn x)) s;;

(*
# list_of_sequence(map_sequence (fun x -> x + 3) (gp 2 10 2)) ;;
- : int list = [5; 7; 11]
*)

let rec filter_sequence fn s = filter_map_sequence (fun x -> if (fn x) then Some x else None) s;;

(*
# list_of_sequence(filter_sequence (fun x -> x mod 3 = 2) (gp 2 12 2)) ;;
- : int list = [2; 8]
# list_of_sequence(cut_sequence 4 (filter_sequence (fun x -> x mod 5 = 0)
triangles)) ;;
- : int list = [0; 10; 15; 45]
*)

(* -------------------------------------------------------------------------------------------------- *)
(* Section 3 : Making Modules                                                                         *)
(* -------------------------------------------------------------------------------------------------- *)

(*
  3a. Create a simple heap (priority queue) module that matches the interface provided below.

      In the section below, fill out the signature and the implementation details. You must explicitly leave any
      types in the signature abstract. (This is good practice in the software engineering sense. By not explicitly
      binding the types on the interface, you allow different implementations to choose types best suited
      for their goals)

      Your heap implementation does not need to be efficient.
      You are not permitted to just wrap the OCaml heap in this interface.

      You should use the generic compare function; there are better ways, but they're more
      complicated.

      NOTE: When you query the type of your functions in the top loop, it might return the fully qualified type signatures.
      E.g: empty : unit -> 'a GHeap.heap instead of just unit -> 'a heap. This is fine.
		
      [20 Points]
*)


(* This is a functional heap, no mutation is used. *)
(* This is also found in GHeap.mli *)
(*
module GHeap =
  sig
    type 'a heap

    (* The method returns a *new* empty heap instance *)
    val empty : unit -> 'a heap

    (* Insert a new value into the heap *)
    val insert : 'a -> 'a heap -> 'a heap

    (* Return the smallest value in the heap and the heap that results when it is removed. Return None if the heap is empty. *)
    val find_min : 'a heap -> ('a * 'a heap) option

    (* Return a list containing the elements of the heap in ascending order. *)
    val as_sorted_list : 'a heap -> 'a list
  end
;;
*)

(*
$ ocamlc GHeap.mli
$ ocamlc -c GHeap.ml
$ ocaml
# #load "GHeap.cmo";;
# let q1 = GHeap.empty () ;;
val q1 : '_a GHeap.heap = <abstr>
# GHeap.find_min q1 ;;
- : ('_a * '_a GHeap.heap) option = None
# let q2 = GHeap.insert 1 q1 ;;
val q2 : int GHeap.heap = <abstr>
# GHeap.find_min q2 ;;
- : (int * int GHeap.heap) option = Some (1, <abstr>)
# let q3 = GHeap.insert 2 q2 ;;
val q3 : int GHeap.heap = <abstr>
# let Some (x, q4) = GHeap.find_min q3 ;;
Warning 8: this pattern-matching is not exhaustive.
Here is an example of a value that is not matched:
None
val x : int = 1
val q4 : int GHeap.heap = <abstr>
# GHeap.find_min q4 ;;
- : (int * int GHeap.heap) option = Some (2, <abstr>)
# GHeap.as_sorted_list q3 ;;
- : int list = [1; 2]
*)


open GHeap;;

(* Write the following functions for your heap; you should not need to add them to your interface. *)

(* This function takes a list of elements and inserts each of them into the heap *)
let rec insert_many (xs : 'a list) (h : 'a heap) : 'a heap = match xs with | [] -> h | head :: t -> insert_many t (insert head h) ;;

(* This function returns the smallest element in the heap *)
let rec get_min (h : 'a heap) : 'a = match (find_min h) with | None -> None | Some (v, hnew) -> v;;

(* This function returns the heap with its smalles element deleted *)
let rec delete_min (h : 'a heap) : 'a heap = match (find_min h) with | None -> h | Some (v, hnew) -> hnew;;

(* Now write "heap sort" (or at least, it would be heap sort if your heap were efficient) *)

let rec heap_sort (xs : 'a list) : 'a list = as_sorted_list (insert_many xs (empty ()) );;

(* -------------------------------------------------------------------------------------------------- *)
(* Section 4 : Symbolic Computations                                                                  *)
(* -------------------------------------------------------------------------------------------------- *)

(*
   Recall that a polynomial function is one that can be represented as
   f(x) = a_0 * x^0 + a_1 * x^1 + ... + a_n * x^n
   for some sequence of integers a_0, a_1, ..., a_n;
   https://en.wikipedia.org/wiki/Polynomial#Polynomial_functions
   In this section, we're going to represent polynomials as non-empty lists of
   integers [a_0; a_1; ...; a_n].

   [30 Points]
*)

(* 4a. Write a function to evaluate a polynomial at a particular input *)
let rec eval_polynomial p n = let pow x y = int_of_float ((float_of_int x ) ** (float_of_int y)) in
		let rec polyhelp p n i =
		match p with
		| [] -> 0
		| h :: t -> h * (pow n i) + polyhelp t n (i+1)
		in polyhelp p n 0;; 

(*
# eval_polynomial [0] 4 ;;
- : int = 0
# eval_polynomial [1;0;1] 4 ;;
- : int = 17
# eval_polynomial [3;2;1] (-2) ;;
- : int = 3
*)

(* 4b. Write a function compute the derivative of a polynomial

   https://en.wikipedia.org/wiki/Polynomial#Calculus *)
let rec deriv p = let rec derivhelp p i = match p with 
| h :: [] -> []
| h1 :: h2 :: t -> (h2 * i) :: (derivhelp (h2 :: t) (i+1))
in match (derivhelp p 1) with | [] -> [0] | x -> x;;

(*
# deriv [1] ;;
- : int list = [0]
# deriv [1;2;3] ;;
- : int list = [2;6]
*)

(*
  4c. Write a function to add two polynomials
*)
let rec add_poly p1 p2 = 
	let rec zipWith f xs ys = 
	match xs, ys with 
	| [], [] -> []
	|  x, [] -> x 
	| [],  y -> y
	| xshead :: xstail, yshead :: ystail -> (f xshead yshead) :: zipWith f xstail ystail
	in zipWith (+) p1 p2;;

(*
# add_poly [1;2] [3;0;4] ;;
- : int list = [4;2;4]
*)

(*
  4d. Write a function to multiply two polynomials.
*)
let rec mul_poly p1 p2 = let rec padfront i = if i = 0 then [] else 0 :: padfront (i-1) in
	let rec polyhelper p1 p2 i =
	match p1 with 
	| h :: [] -> (padfront i) @ (List.map (fun x -> x * h) p2)
	| h :: t -> add_poly ((padfront i) @ (List.map (fun x -> x * h) p2)) (polyhelper t p2 (i+1))
	in polyhelper p1 p2 0;;

(*
# mul_poly [-1] [3;0;4] ;;
- : int list = [-3;0;-4]
# mul_poly [1;1] [3;0;4] ;;
- : int list = [3;3;4;4]
*)


(*
  4e. Write a function to divide a polynomial by another, giving back a pair of
      a quotient and a remainder.
*)
(*
let rec div_helper dividend divisor quotient remainder = 
	let h2ldividend = List.rev dividend in
	let h2ldivisor = List.rev divisor in
	if List.length h2ldivisor 
	match dividend, divisor with 
	|   

let rec div_poly p1 p2 = (* ANSWER *) ;;



(*
# div_poly [3;3;4;4] [3;0;4] ;;
- : (int list * int list) = ([1;1], [0])
# div_poly [3;3;4;4] [0;0;4] ;;
- : (int list * int list) = ([1;1], [3;3])
*)

(*
  4f. Write a function to compute the Greates Common Divisor (gcd) of two
      polynomials.

      https://en.wikipedia.org/wiki/Greatest_common_divisor
*)
let rec gcd p1 p2 = (* ANSWER *) ;;

(*
# gcd [3;3;4;4] [3;0;4] ;;
- : int list = [3;0;4]
# gcd [2;4] [3;6] ;;
- : int list = [1;2]
# gcd [1;2;1] [2;2] ;;
- : int list = [1;1]
*)

(* -------------------------------------------------------------------------------------------------- *)
(* Section 5 : Mutable State and Memoization                                                          *)
(* -------------------------------------------------------------------------------------------------- *)

(*
  5. Cache: Pure functions (those without side effects) always produces the same value
     when invoked with the same parameter. So instead of recomputing values each time,
     it is possible to cache the results to achieve some speedup.

     The general idea is to store the previous arguments the function was called
     on and its results. On a subsequent call if the same argument is passed,
     the function is not invoked - instead, the result in the cache is immediately
     returned.

     Note: you will need to use mutable state in some form to implement the cache.

     [10 Points]
*)

(*
  Given any function f as an argument, create a function that returns a
  data structure consisting of f and its cache
*)
let new_cached_fun f = () (* ANSWER *)

(*
  Write a function that takes the above function-cache data structure,
  applies an argument to it (using the cache if possible) and returns
  the result
*)
let apply_fun_with_cache cached_fn x = () (* ANSWER *)

(*
  The following function makes a cached version for f that looks
  identical to f; users can't see that values are being cached
*)

let make_cached_fun f =
  let cf = new_cached_fun f in
    function x -> apply_fun_with_cache cf x
;;


(*
let f x = x + 1;;
let cache_for_f = new_cached_fun f;;
apply_fun_with_cache cache_for_f 1;;
cache_for_f;;
apply_fun_with_cache cache_for_f 1;;
cache_for_f;;
apply_fun_with_cache cache_for_f 2;;
cache_for_f;;
apply_fun_with_cache cache_for_f 5;;
cache_for_f;;
let cf = make_cached_fun f;;
cf 4;;
cf 4;;


# val f : int -> int = <fun>
# val cache_for_f : ...
# - : int = 2
# - : ...
# - : int = 2
# - : ...
# - : int = 3
# - : ...
# - : int = 6
# - : ...
# val cf : int -> int = <fun>
# - : int = 5
# - : int = 5
*) *)