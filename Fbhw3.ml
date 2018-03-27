(*
    600.426 - Programming Languages
    JHU Spring 2016
    Homework 3

    Now that you have completed your Fb interpreter, you will need to write some
    programs in Fb.

    Note: We will be testing your Fb code with the canonical interpreter (binary) that was
    provided to you. So it is worth your while to test your code against that prior to submitting
    it.
*)

(* -------------------------------------------------------------------------------------------------- *)
(* HEADER: PLEASE FILL THIS IN                                                                        *)
(* -------------------------------------------------------------------------------------------------- *)

(*

  Name                  :  Graham Smith
  List of team Members  :  Graham Smith (solo)
  List of discussants   :  Graham Smith (solo)

*)

(* -------------------------------------------------------------------------------------------------- *)
(* Section 1 : Operational Semantics and Proofs                                                       *)
(* 15 Points                                                                                          *)
(* -------------------------------------------------------------------------------------------------- *)

(*
  1a. The operational semantics for Fb provide a set of proof rules which are
  used by the interpreter to perform evaluation. In this problem, you will build
  a proof by hand. Write an operational semantics proof which demonstrates that
  the Fb expression "(Fun f -> Fun y -> y f) True (Fun z -> If z Then 1 Else 0)"
  evaluates to 1.

  Your proof should follow the Fb operational semantics rules correctly and not
  skip any steps.

*)


(* 
(Fun f -> Fun y -> y f) True (Fun z -> If z Then 1 Else 0) => 1
  because (Fun f -> Fun y -> y f) True (Fun z -> If z Then 1 Else 0) => (Fun z -> If z Then 1 Else 0) True
    because (Fun f -> Fun y -> y f) True => (Fun y -> y True)
		  because (Fun f -> Fun y -> y f) => (Fun f -> Fun y -> y f)
			and True => True
			and (Fun y -> y True) => (Fun y -> y True)
		and (Fun y -> y True) (Fun z -> If z Then 1 Else 0) =>  1
		  because (Fun y -> y True) => (Fun y -> y True)
			and (Fun z -> If z Then 1 Else 0) True => 1
			  because  (Fun z -> If z Then 1 Else 0) => (Fun z -> If z Then 1 Else 0)
				and True => True
				and If True Then 1 Else 0 => 1
				  because True => True
					and 1 => 1

*)
(*  ANSWER *)

(*
  1b. Many languages provide a way to chain If-Then-Else expressions. Fb
  doesn't, per se, but due to its parse rules
  "If x = 0 Then 1 Else If x = 1 Then 2 Else If x = 2 Then 4 Else 0"
  evaluates the way you'd expect.

  Write operational semantics for "If e Then e (ElseIf e Then e)* Else e End",
  where (ElseIf e Then e)* means that the parenthesized grammar term may be
  repeated 0 or more times (the parentheses are not part of the syntax).

  They should be properly short-circuiting and their evaluation should look
  similar to the evaluation of the "Else If" chain in Fb.
*)

(*

	let q be a metavariable for a list representing arbitrarily many (ElseIf ex Then ey) 
	fragments as Ocaml tuples (ex,ey)
	and let [rem] be an action like subst to be performed on a list of fragments that removes 
	the first element of the list, such that [frag1; frag2; frag3][rem] => [frag2; frag3]
	and let [head] be a similar action that evaluates to the head of the list,
	such that [frag1; frag2; frag3][head] => frag1 (=> (ex,ey))
	and let [empty] be another action that returns True when applied to an empty list (false otherwise)
	such that q[empty] => True iff q is empty
	
	If True (ElseIf) Rule:
	
	e1 => True   e2 => v
	_____________________________
	If e1 Then e2 q Else e3 End => v
	
	If False&Empty (ElseIf) Rule:
	
	e1 => False  q[empty] => True  e3 => v
	_____________________________
	If e1 Then e2 q Else e3 End => v
	
	If False&NotEmpty (ElseIF) Rule:
	
	e1 => False 	q[empty] => False  q[head] => (ex, ey)   If ex Then ey q[rem] Else e3 End => v
	____________________________________________________________________________________________
	If e1 Then e2 q Else e3 End => v
	
	
	
*)

(* ANSWER *)

(*
  1c. The Freeze and Thaw operations are defined as macros in the book. But it
  is equally feasible to augment Fb with new operations "Freeze e" and "Thaw e"
  with a similar behavior. Assuming we add these 2 operations to Fb, write out
  the operational semantics for both.
*)

(*

We add Freeze (expression) to our list of terminal values so that e is not evaluated unless Thawed
(Here we assumed you can't Thaw something that hasn't been explicitly frozen)

Freeze Rule:

_____________________
Freeze e => Freeze e


Thaw Rule:

e => Freeze e2   e2 => v
_________________________
Thaw e => v

*)
(* ANSWER *)


(* -------------------------------------------------------------------------------------------------- *)
(* Section 2 : (En)Coding in Fb                                                                       *)
(* 20 Points                                                                                          *)
(* -------------------------------------------------------------------------------------------------- *)

(*
    The answers for this section must be in the form of Fb ASTs. You may assume that
    "fbdktoploop.ml" has been loaded before this code is executed; thus, you may use
    the parse function to create your answer if you like. Alternately you can create
    ASTs directly.

    For instance, the two definitions of the identity function in Fb are equivalent. (See below)
    The second one directly declares the datastructure produced by the first expression.

    You may use whichever form you please; the parse form is somewhat more readable, but
    the AST form allows you to create and reuse subtrees by declaring OCaml variables.

    For questions in this section you are not allowed to use the Let Rec syntax even if you
    have implemented it in your interpreter. Any recursion that you use must entirely be in
    terms of Functions. Feel free to implement an Fb Y-combinator here.  For examples and
    hints, see the file "src/Fb/fbexamples.ml" in the FbDK project.

    Remeber to test your code against the standard Fb binaries (and not just your own
    implementation of Fb) to ensure that your functions work correctly.
*)

let fb_identity_parsed = parse "Function x -> x";;

let fb_identity_ast = Function(Ident("x"), Var(Ident("x")));;

(*
  1a. Fb is such a minimalisitc language that it does not even include a
      less-than operation. But it is possible to create one of your own.

      But we're not going to ask you to create a less-than operation (that is, a
      function which takes an integer and produces a boolean). We're going to
      ask you to create a function that expects 4 arguments: an Int and 3
      Functions; depending on whether the Int is negative, zero, or positive, it
      calls the first, second, or third function, passing it the Int.

      Hint: a) You can call upon your powers of recursion ;) b) We dont really
      care about efficiency.

      [5 Points]
*)

(*let rec findparity k n = if (k + n) = 0 then -1 else if (k-n) = 0 then 1 else findparity k (n+1);;*)

let fbCond = parse "Let Rec ispos k =
	                    Function n -> 
	                    If ((k + n) = 0) Then False 
											Else 
											  If ((k - n) = 0) Then True 
												Else ispos k (n + 1) 
										In Function i -> Function negf -> Function zerof -> Function posf -> If (i = 0) Then (zerof i) 
										                                                                     Else 
																																												   If (ispos i 1) Then (posf i) 
																																													 Else (negf i)" ;; (* ANSWER *)

(*
# ppeval (Appl(parse
  "Fun fbCond -> fbCond 3 (Fun a -> 1) (Fun b -> 0) (Fun c -> c + 1)"
  , fbCond)) ;;
==> 4
- : unit = ()
# ppeval (Appl(parse
  "Fun fbCond -> fbCond 0 (Fun a -> 1) (Fun b -> 0) (Fun c -> c + 1)"
  , fbCond)) ;;
==> 0
- : unit = ()
*)

(*
  2b. Fb is a simple language. But even it contains more constructs than
      strictly necessary For example, you dont really need integer values at
      all! They can be encoded using just functions using what is called
      Church's encoding http://en.wikipedia.org/wiki/Church_encoding

      Essentially this encoding allows us to represent integers as functions.

      For example:
        0 --> Function f -> Function x -> x
        1 --> Function f -> Function x -> f x
        2 --> Function f -> Function x -> f (f x)

      We will write 4 functions that work with church numerals in this section.
      Remember that all your answers should generate Fb ASTs.

      You can assume that we are dealing with only non-negative integers in this
      question.
*)

(* Write a Fb function to convert a church encoded value to an Fb native integer.*)
let fbUnChurch = parse "Function church -> church (Function x -> x + 1) 0" ;; (* ANSWER *)

(* Write a Fb function to convert an Fb native integer to a Church encoded value *)
let fbChurch = parse "Let Rec t i = Function f -> Function x -> If i = 0 Then x Else f (t (i-1) f x) In t" ;; (* ANSWER *)


(*
# let church2 = parse "Function f -> Function x -> f (f x)";;
val church2 : Fbast.expr =
  Function (Ident "f",
   Function (Ident "x",
    Appl (Var (Ident "f"), Appl (Var (Ident "f"), Var (Ident "x")))))
# ppeval (Appl(fbUnChurch,church2));;
==> 2
- : unit = ()
# ppeval (Appl(fbUnChurch,Appl(fbChurch,Int(12))));;
==> 12
- : unit = ()
# ppeval (Appl(Appl(Appl(fbChurch,Int(4)),(parse "Function n -> n + n")),Int(3)));;
==> 48
- : unit = ()
*)

(* For these two functions, you are not allowed to call fbUnChurch, do the math,
   and then fbChurch the result *)

(* Write a function to add two church encoded values *)
let fbChurchAdd = parse "Function ch1 -> Function ch2 -> Function f -> Function x -> ch1 f (ch2 f x)" ;; (* ANSWER *)

(* Write a function to multiply two church encoded values *)
let fbChurchMul = parse "Function ch1 -> Function ch2 -> Function f -> Function x -> ch1 (ch2 f) x" ;; (* ANSWER *)

(*
# let church2 = parse "Function f -> Function x -> f (f x)" ;;
# let church3 = parse "Function f -> Function x -> f (f (f x))" ;;
# ppeval (Appl(fbUnChurch, (Appl(Appl(fbChurchAdd, church3), church2))));;
==> 5
- : unit = ()
# ppeval (Appl(fbUnChurch, (Appl(Appl(fbChurchMul, church3), church2))));;
==> 6
- : unit = ()
*)

(*
  2c. Church encoding is not the only way to represent natural numbers in lambda
      calculus (basically the same as Fb without integers or booleans). There is
      also something called Scott encoding:
      https://en.wikipedia.org/wiki/Mogensen%E2%80%93Scott_encoding

      Although it is more verbose than the Church encoding, it makes it much
      easier to manipulate the resulting functions as though they were just data
      (like OCaml data-types).

      Write the same four functions you from above for Scott numerals, and also
      write the predecessor function.

      0  -->  Fun s -> Fun z -> z
      1  -->  Fun s -> Fun z -> s 0  --> Fun s -> Fun z -> s (Fun s -> Fun z -> z)
      2  -->  Fun s -> Fun z -> s 1  -->
                   Fun s -> Fun z -> s (Fun s -> Fun z -> s (Fun s -> Fun z -> z))
*)

(* Write a Fb function to convert a Scott encoded value to an Fb native integer.*)
let fbUnScott = parse "Let Rec help scott = 
	                     Function i -> scott (Function subscott -> help subscott (i+1)) i 
											 In Function scott -> help scott 0" ;;


(* Write a Fb function to convert an Fb native integer to a Scott encoded value *)
let fbScott = parse "Let Rec t i = Function s -> Function z -> If i = 0 Then z Else s (t (i-1)) In t" ;; (* ANSWER *)

(* For these three functions, you are not allowed to call fbUnScott, do the math,
   and then fbScott the result *)

(* Write a function to add two church encoded values *)
let fbScottAdd = parse "Let Rec help sc1 = 
	                      Function sc2 -> 
												(sc1 (Function subscott -> Function s -> Function z -> s (help subscott sc2) ) sc2)
											  In Function sc1 -> Function sc2 -> help sc1 sc2" ;; (* ANSWER *)
(* ppeval (Appl(fbUnScott, (Appl(Appl(fbScottAdd, scott5), scott6))));; *)


(* Write a function to multiply two church encoded values *)
let fbScottMul = parse "" ;; (* ANSWER *)

(* Write the predecessor function. *)

let fbPred = parse "Fun x -> If x = 0 Then 0 Else x - 1"

(* The Church encoding of predecessor is hard; the Scott encoding is relatively
   straightforward. *)
let fbScottPred = parse "Function scott -> scott (Function x -> x) 0" ;; (* ANSWER *)



(*
  2d. Now try your hand at a list encoding. The two functions which follow
      convert between *OCaml* lists and encoded Fb lists.
*)

(* Produce an expression that evaluates to an Fb encoded list given an OCaml
   list. The elements of the OCaml list are Fb expressions, but your list
   should contain only values.
   
   Note: there are two primary ways to do this:
       1. Have your OCaml code evaluate the expressions before putting them in
          the Fb AST (or string which you will parse to an AST).
       2. Leave the expressions as expressions in the Fb code, relying on the
          interpreter to evaluate them; if you do this, make sure they do get
          evaluated.

   Running `eval (fbList [parse "1"; parse "1 + True"])` should result in an Fb
   runtime error. If it does not, you are not evaluating the expressions.

   If you are taking the first approach, you should produce Fb code which will
   have a runtime error in this case.
*)
let fbList ocaml_list_of_Fb_expressions = parse "" ;; (* ANSWER *)

(* Produce an OCaml list of Fb values given an an expression which evaluates to
   an Fb encoded list, possibly containing expressions. You will need to call
   `eval` in this function.
   
   Throw an exception if you encounter an Fb error, or if the Fb expression
   does not evalute to an Fb list.

   `fun x -> let y = fbUnList x in map eval y = y` should be true for any input
   unless an exception is thrown.

   Again, there are two primary ways to do this:
       1. Have OCaml evaluate the expression and pull it apart, evaluating the
          components as necessary.
       2. Write an Fb function which takes a list and evaluates each element of
          it, constructing a new list of values; then use eval once to call
          this function on your input before using OCaml to pull apart your Fb
          encoded list, secure in the knowledge that its elements are values.
*)
let fbUnList encoded_Fb_list = parse "" ;; (* ANSWER *)