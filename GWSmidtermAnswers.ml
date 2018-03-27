600.426 - Principles of Programming Languages
Spring 2016
Take Home Midterm

----------------------------------------------------------------------------------------
INSTRUCTIONS
----------------------------------------------------------------------------------------

This is a Take Home Midterm and as such operates on different rules from your regular
assignments. You are expected to work on solving these problems by yourself. You are
encouraged to talk to the TAs/Prof in office hours if you are stuck. You may discuss
general concepts with others but you are NOT allowed to discuss the particular questions
with anyone other than the Prof/TAs.

----------------------------------------------------------------------------------------
HEADER: PLEASE FILL THIS IN
----------------------------------------------------------------------------------------

Name : Graham Smith

----------------------------------------------------------------------------------------
Questions
----------------------------------------------------------------------------------------

1. [10 Points] Its time to reverse engineer some operational semantics proofs.  For each
fragment below, build out a full instance of the application rule for Fb which has the
indicated substitution above the line.  Well, some are impossible - indicate which are
impossible if no derivation can be built.  (Recall that for e ==> v, both e and v must
be closed.)

Example question: y[4/y] ==> ..
Example Answer:

(Fun y -> y) ==> (Fun y -> y)    4 ==> 4    y[4/y] ==> 4
---------------------------------------------------------
       (Fun y -> y)(4) ==> 4


Raw (for copy-paste and reference):

e1 ==> (Fun x -> e)    e2 ==> v    e[v/e] ==> v2
---------------------------------------------------------
       e1 e2 ==> v2

     a. (x + y)[3/x] ==> ..
		
		Impossible. The application rule only has substitution in one place that must evaluate to a value.
		(x + y)[3/x] would evaluate to (3 + y) which is not a value.
		
     b. (Function x -> x + y)[3/y] ==> ...
		
		(Fun y -> Fun x -> x + y) ==> (Fun y -> Fun x -> x + y)    3 ==> 3    (Function x -> x + y)[3/y] ==> (Fun x -> x + 3)
---------------------------------------------------------
       (Fun y -> Fun x -> x + y) 3 ==> (Fun x -> x + 3)
		
     c. (Function x -> x + 1)[3/x] ==> ...
		
		(Function x -> Function x -> x + 1) ==> (Function x -> Function x -> x + 1)    3 ==> 3    (Function x -> x + 1)[3/x] ==> (Function x -> x + 1)
---------------------------------------------------------
       (Function x -> Function x -> x + 1)(3)  ==> (Function x -> x + 1)
		
		
     d. x [(Function x -> x + x)/x] ==> ...
		
		(Fun x -> x) ==> (Fun x -> x)    (Function x -> x + x) ==> (Function x -> x + x)   x [(Function x -> x + x)/x] ==> (Function x -> x + x)
---------------------------------------------------------
       (Fun x -> x)(Function x -> x + x)  ==> (Function x -> x + x)
		


2. [10 points] The operational semantics for FbX included various rules to "bubble" up any
    exception raised; in HW4B we asked for you to write out all the bubbling rules for a
    hypothetical "Implies" extension to appreciate the subtleties of bubbling.  For this
    question, writing the "Implies" clause for an FbXI interpreter. The types will look
    something like this (... are the old Fb items):

    type exnlab = string

    type expr = ... Implies of expr * expr | ...
                 | Raise of exnlab * expr
                 | Try of expr * exnlab * ident * expr

    let rec eval e = match e with ...
       Implies(e1,e2) -> ( match ( eval e1 , eval e2 ) with
			    | ( Raise(xlab,xpr), _) -> Raise(xlab,xpr)
					| ( _, Raise(xlab,xpr)) -> Raise(xlab,xpr) 
          | ( False , _ ) -> True
          | ( True , True ) -> True
          | ( True , False ) -> False )
       
    All you need to do for this quesiton is to write out the evaluator clause for Implies.
    Make sure to get the spirit of bubbling implemented in your interpreter as it was
    specified in the rules.  Make sure to not use OCaml exceptions to implement FbXI
    exceptions.


3.  [15 points] Consider the language FbD - Fb augmented with immutable dictionaries (maps). 
   Dictionaries map keys to values. The following is the concrete syntax for dictionaries:
   - Literal syntax for creating dictionaries: { `key1 => e1 ; ... `keyn => en } 
     E.g. { `Foo => False ; `Bar => 1 + 3 ; `Moo => 10 } 
     (Notice the special syntax for keys)
   - Accessing values by key: e[`key]
     E.g. { `Foo => False ; `Bar => 1 + 3 }[`Bar] results in 4
   - Append dictionary: e @@ e' produces a new dictionary that appends the right
   dictionary to the left.  Mappings in e' have priority over those in e.


     E.g { `Foo => 1 } @@ {`Bar => False} results in { `Foo => 1; ` Bar => False} and
         { `Foo => 1 } @@ {`Foo => False; `Bar => True} results in  { `Foo => False; `Bar => True }

    a. Write the operational semantics for FbD.
		                                              
       dictionaries are both a new kind of value
       as well as a new expression. 
			 dictionary keys of of form `keylabel and `l is a metavariable for them
			
			Dict Creation Rule (/Value Rule):
			
			                e1 => v1,  ...  en => vn
			______________________________________________________________
			{ `l1 => e1 ; ... `ln => en } => { `l1 => v1 ; ... `ln => vn }
			
			Select Rule:
			
			e1 => { `l1 => v1 ; ... `lq=>vq ; ... `ln => vn }
			_________________________________________________
			                 e1[`l] => vq
			
			
			Append Rule:
			
			e1 => { `l1a => v1a ; ... `lna => vna }, e2 => { `l1b => v1b ; ... `lmb => vmb }
			____________________________________________________________________________________________________________________________
			e1 @@ e2 => { `l1b => v1b ; ... `lmb => vmb ; `l1a => v1a ; ... `lna => vna } where any `l#a that matches a `l#b is excluded

      (alternatively, I could recursively call the append rule by having e1 @@ e2 => dict1 @@ dict2' where dict2' has keys in dict1 removed, and a 
			 base rule for e1 @@ e2 where all keys are distinct. Another alternative, I could internally use analogs of the <+ Override/Extend
			 operator/Rules for records in the HW4b and have e1 @@ e2 => dict1' @@ dict2' where dict1' is dict1 <+ the first element of dict2 and dict2' 
			is dict2 with the first element removed. Then I would have a base case with e1 @@ e2 where e2 evaluates to an empty dictionary.)

    b. Assume that the abstract syntax for FbD is like this:

       type key = Key of string
       type expr = ... | Dict of (key * expr) list | Get of expr * key | Append of expr * expr

       where (... indicates the original Fb AST) 

       Write eval function for FbD. Like for the FbXI question, you only need to specify
       the new cases that need to be added to the Fb interpreter.  Your code need not run,
       but of course you are welcome to run it to help debug it.

          | Dict(dictlst) -> ( let rec evalList lst = match lst with
					                     | [] -> []
															 | (Key(s),e) :: t -> (Key(s), (eval e)) :: (evalList t)
															 | _ -> raise Bug
														in Dict(evalList dictlst) ) 
						
					| Get(e, k) -> match (eval e, k) with
					    | ( Dict(dictlst), Key(s) ) -> let rec get lst ks = match lst with
							                               | [] -> raise KeyNotFound
															               | (Key(s),v) :: t -> if (s=ks) then v else (get t ks) 
															               | _ -> raise Bug
																						in (get dictlst s)	
							| _ -> raise Bug	 
					
					| Append(e1, e2) -> match (eval e1, eval e2) with 
					    | (Dict(dictlst1), Dict(dictlst2)) -> 
								      (let rec lackskey k dlst = match dlst with
                        | [] -> true
                        | (Key(s),v) :: t -> if (k = s) then false else lackskey k t
												| _ -> raise Bug
											in (let rec appendDlists dl1 dl2 = match dl1 with
											     | [] -> dl2
													 | (Key(s),v) :: t -> if (lackskey s dl2) then ((Key(s),v) :: (appendDlists t dl2)) else (appendDlists t dl2)
													 | (Key(s),v) :: t -> if (lackskey s dl2) then ((Key(s),v) :: (appendDlists t dl2)) else (appendDlists t dl2)
											     | _ -> raise Bug
											in (Dict((appendDlists dictlst1 dictlst2))))) 
						  | _ -> raise Bug 



4.  [10 Points] For the following expressions, give TFb proof trees demonstrating the
    following typings, or show that no such proof tree can exist, i.e. the program is not
    typeable.  The "(fill in)" you can pick any type for, the idea is to try to find a
    type such that a full proof tree can be built, or argue why that is impossible by
    showing any tree construction must fail.

    I will write G as capital gamma and |- as the sideways t symbol

     a. (Fun f: (Int -> Bool) -> Not (f 4))(Fun x: Int -> x = 1)
		
                                                                                                                 
      ________________________________________      _____________________________                                                                                
		    G, f: (Int->Bool) |- f : (Int->Bool)    ,   G, f: (Int->Bool) |- 4 : Int                                                                                         
		  ___________________________________________________________________________           ________________       __________________                                                                   
		            G, f: (Int->Bool) |- (f 4) : Bool                                       G,x:Int |- x:Int   ,   G,x:Int |- 1 : Int                                                                       
		           ______________________________________                                    ________________________________________                                                                      
		           G, f: (Int->Bool) |- Not (f 4)) : Bool                                          G,x:Int |- (x = 1) : Bool                                                                   
		    ________________________________________________________________            __________________________________________                                                          
		       G |- (Fun f: (Int->Bool) -> Not (f 4)) : (Int->Bool)->Bool         ,      G |- (Fun x: Int -> x = 1) : (Int->Bool)  
		________________________________________________________________________________________________________________________________
		                      G |- (Fun f: (Int->Bool) -> Not (f 4))(Fun x: Int -> x = 1) : Bool
		
     b. (Fun x : (fill in ) -> x x )
		Impossible. In the body of the function, x is being applied to itself. Let's assume that x is type T. Then we immediately reach a contradiction,
		because if the second x in "x x" is type T, then the first must be type T -> something. x can only have one type, and cannot be resolved here.
  
5.  [5 Points]  This question concerns STFb subtyping. Write a subtype of the following type:

(( {m : Int} -> {d : {x:Int; y:Int}} ) -> {w: Int; q: Int; p:Int}) -> Int

where none of the component-record types of your subtype should be identical to the
corresponding record types of the above type (this condition is added becase the type is a
subtype of itself but we don't want that answer).  Show your work: give the full proof
tree using the subtyping rules for STFb.

To get a subtype of (( {m : Int} -> {d : {x:Int; y:Int}} ) -> {w: Int; q: Int; p:Int}) -> Int
I need a supertype of (( {m : Int} -> {d : {x:Int; y:Int}} ) -> {w: Int; q: Int; p:Int})
Which means I need a subtype of  ( {m : Int} -> {d : {x:Int; y:Int}} ) and a supertype of {w: Int; q: Int; p:Int}*
Which means I need a supertype of {m : Int}* and a subtype of {d : {x:Int; y:Int}}*

*
supertype of {w: Int; q: Int; p:Int} --> {}
supertype of {m : Int} --> {}
subtype of {d : {x:Int; y:Int}} --> {d :{x:Int; y:Int; z:Int}}

Which results in:
(( {} -> {d : {x:Int; y:Int; z:Int}} ) -> {}) -> Int

normally there is a numerator here for the subrecord rule, but of form "|- t1 <: t1', ..., tn <: tn'", but n is 0 so it's empty
    |                           __________  __________                                               |
    |                        |- Int <: Int, Int <: Int                                               |
    |                      __________________________________________                                |
    v                     |- {x:Int; y:Int; z:Int} <: {x:Int; y:Int}                                 |
_______________         ___________________________________________________                          |
{m : Int} <: {}     ,   {d : {x:Int; y:Int; z:Int}} <: {d : {x:Int; y:Int}}                          v
_______________________________________________________________________________        ______________________________
( {} -> {d : {x:Int; y:Int; z:Int}} ) <: ( {m : Int} -> {d : {x:Int; y:Int}} )   ,     {w: Int; q: Int; p:Int} <: {}
___________________________________________________________________________________________________________________
(( {m : Int} -> {d : {x:Int; y:Int}} ) -> {w: Int; q: Int; p:Int}) <: (( {} -> {d : {x:Int; y:Int; z:Int}} ) -> {})  ,  Int <: Int
________________________________________________________________________________________________________________________________________
(( {} -> {d : {x:Int; y:Int; z:Int}} ) -> {}) -> Int   <:   (( {m : Int} -> {d : {x:Int; y:Int}} ) -> {w: Int; q: Int; p:Int}) -> Int



