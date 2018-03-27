600.426 - Programming Languages
JHU Spring 2016
Homework 5

--------------------------------------------------------------------------------------------------
HEADER: PLEASE FILL THIS IN
--------------------------------------------------------------------------------------------------

Name                  : Graham Smith
List of team Members  : Graham Smith (solo)
List of discussants   : Graham Smith (solo)

----------------------------------------------------------------------------------------
  Section 1: Type Rules and Subtyping
----------------------------------------------------------------------------------------

1a. We defined a language FbD - Fb with extensible dictionaries, in the midterm. In this
    exercise we extend it to TFbD - FbD with typechecking. Write down the new type rules
    needed for the language (beyond those already provided by TFb).  Make sure to type the
    construction as well as the append and access of dictionaries.

    You can assume that the syntax of FbD has been extended to allow the specification
    of types for dictionaries as  { `Foo => Bool ; `Bar => Int ; `Moo => Int }.


    I will write G as capital gamma and |- as the sideways t symbol

    Construction:
		
		                 G |- e1 : t1, ... G |- en : tn
		_____________________________________________________________________
		G |- { `l1 => e1 ; ... `ln => en }  :  { `l1 => t1 ; ... `ln => tn }

   
	  
	  Access:
		
		G |- e1 : {`l1 => t1 ; ... `lq : tq ; ... `ln : tn }
		______________________________________________________
                     G |- e1[`lq] : tq


    Append:
		G |- e1 : {`l1a => t1a ; ... `lna => tna} , G|- e2 : {`l1b => t1b ; ... `lmb => tmb}
		__________________________________________________________________________________________________________________________________
		G |- e1 @@ e2 : {`l1b => t1b ; ... `lmb => tmb ; ... `l1a => t1a ; ... `lna => tna} where any `l#a that matches a `l#b is excluded


 b. Consider hypothetical language STFbD, adding subtyping to the above.  This is in fact
    very difficult due to the challenges of subtyping.  To illustrate the problem consider
    trying to typecheck

     Fun x: { `Foo => Bool } -> Fun y: { `Bar => Int } -> x @@ y

    Write a sentence or two on why the append typing rule would be difficult to write in
    the presence of subtyping.

    Consider the function above. If a subtype of {`Bar => Int} is the second argument, then the result of the expression above 
		might not be a subtype of { `Foo => Bool ; `Bar => Int }, such as if the second argument has type {`Bar => Int ; `Foo => Int },
    The behaviour of this expression's typing is pretty unpredictable and therefore difficult to deal with.


 c. Give a type derivation in STFbR showing how the following program typechecks:
    Let getradius = (Fun p : {r:Int} -> p.r) In
      getradius {r = 4; t = 180} + getradius {r = 5; t = 120; g=128}

    According to a Piazza post this is a macro for :
    (Fun getradius : ({r:Int} -> Int) -> getradius {r = 4; t = 180} + getradius {r = 5; t = 120; g=128}) (Fun p : {r:Int} -> p.r)
		
		I will write G as capital gamma and |- as the sideways t symbol.
		I will also write G2 to mean G, getradius : ({r:Int} -> Int) to save room
		I will also write G3 to mean G, p : {r:Int} to save room
		                    
																	G2 |-	4 : Int , G2 |- 180 : Int				                       
																_______________________________________		_______________________					                                                                                                  
																G2 |- {r = 4; t = 180} : {r:Int;t:Int} , {r:Int; t:Int} <: {r:Int} 					                                                                                                                 
	 ______________________________      ______________________________________                                                                                                                       
	G2 |- getradius : ({r:Int} -> Int) ,  G2 |- {r = 4; t = 180} : {r:Int}                       **Same tree  as to the immediate left, diff numbers**                                                                      
	    ___________________________________________________________________                         ______________________________________________                           ____________________                                                                                                 
	                    	G2 |- getradius {r = 4; t = 180} : Int                           ,        G2 |- getradius {r = 5; t = 120; g=128} : Int                             G3 |- p : {r : Int}   
		                      _____________________________________________________________________________________________________________________                            ___________________   
		                         G2 |- getradius {r = 4; t = 180} + getradius {r = 5; t = 120; g=128} : Int                                                                    G3 |- p.r : Int  
	                     __________________________________________________________________________________________________________________________________	         ________________________________________________ 
                    		G |- (Fun getradius : ({r:Int} -> Int) -> getradius {r = 4; t = 180} + getradius {r = 5; t = 120; g=128}) : ({r:Int} -> Int) -> Int   ,    G |- (Fun p : {r:Int} -> p.r) : ({r:Int} -> Int)
	                                 	________________________________________________________________________________________________________________________________________________________________________________
		                                G |- (Fun getradius : ({r:Int} -> Int) -> getradius {r = 4; t = 180} + getradius {r = 5; t = 120; g=128}) (Fun p : {r:Int} -> p.r) : Int






    [25 Points]


--------------------------------------------------------------------------------------------------
  Section 2: Actors
--------------------------------------------------------------------------------------------------

2a. For this question you are going to write a set data structure of sorts in AFbV.

    An implementation of AFbV is available in the FbDK. It is not multithreaded or
    distributed however as OCaml core libraries don't have such facilities.  Language
    extensions including Let .. In, sequencing ( ; operator ), pairs ( including keywords
    Fst and Snd to extract values ), lists ( supports construction via the :: operator and
    the standard [v1; v2; v3] notation and has keywords Head and Tail to extract the head
    and tail respectively; use "l = []" to check for empty list) and also an ability to
    print integers and booleans.  It does not include Let Rec. You can use the Y
    combinator to get around that and it is easy to do with Let .. In.  If you start the
    interpreter with the --debug flag, it will print out the current set of actors and
    messages before it processes messages. This is useful, but may be too much information
    on screen.  Note that if there is any runtime error you MUST to stop and re-start the
    intepreter, it is flakey and may not work properly otherwise.

    Some AFbV examples run in class may be found at

    http://pl.cs.jhu.edu/pl/ocaml/code/AFbV-examples.afbv


    Here is a sketch of the interface your set should obey.

    Let setbeh = (* FILL IN YOUR SET BEHAVIOR HERE *)  In
    Let s = Create(setbeh,[]) In ...

    so that 

    s <- `add(1); s <- `add(2); s <- `add(3)

    would add all the indicated elements to set s (implemented by an actor).  Then,

    s <- `asList(c)

    should cause s to send all elements of its set, in the form of a list, to
    actor c.


    Fun me -> y (Fun this -> Fun data -> Fun msg ->
         Match msg With
           `add(n) ->  (this (n :: data))
				 | `asList(c) -> (c <- data);
					             
											 (this (data))
				)


    Overall here is a program which should be able to test your set:

    Let y = (Fun b -> Let w = Fun s -> Fun m -> b (s s) m In w w) In
    Let setbeh = 
			
			Fun me -> y (Fun this -> Fun data -> Fun msg ->
         Match msg With
           `add(n) ->  (this (n :: data))
				 | `asList(c) -> (c <- data);
					             
											 (this (data))
				) In
			
			
    Let testbcont = Fun m -> (Print (Head m)); (Print (Head (Tail m)));
                             (Print (Head (Tail (Tail m)))); (Fun x -> x) In
    Let testb = Fun me -> Fun d -> Fun m ->  
       Let s = Create(setbeh, []) In
         (s <- `add(1)); (s <- `add(2)); (s <- `add(3)); (s <- `asList(me));
         (testbcont)
    In Let testa = Create(testb,0)
    In testa <- `anymessage 0

    Observe that the testbcont is the "continuation" of the test, its the behavior which will receieve the list from the set.
    
    [10 points]

 b. One property of actors discussed in class was arrival order nondeterminism, namely
    messages need not arrive in the order they were sent.  Describe how the above set
    actor is not the most reliable data structure given this property.
		
		
		If I ask for the list using an asList message, it is completely uncertain what state the list sent will be in; as List could be 
		processed before any number of messages that were sent earlier to add to the list, or after any number of messages that are sent 
		later to add to the list. In fact, some earlier additions may not be present while some later ones may be. The 
		order of the list need not correspond to the order of additions.

 c. Fix the above set and test so that it will serialize the additions appropriately, by changing the protocol for add to be

      s <- `add(1,c)

    and have your set send an `ack(0) reply to c every time it accomplishes an `add.  Also
    change the test so it waits for the `ack of each `add before sending the next add.
    You will have to use the testbcont idea in the tester above to sequence messages.



Let y = (Fun b -> Let w = Fun s -> Fun m -> b (s s) m In w w) In
    Let setbeh = 
			
			Fun me -> y (Fun this -> Fun data -> Fun msg ->
         Match msg With
           `add(n) ->    ((Snd n) <- (`ack((Fst n))));
						             (this ((Fst n) :: data))
				 | `asList(c) -> (c <- data);
					             
											 (this (data))
				) In 
			
Let s = Create(setbeh, []) In 			
Let testbcont = Fun m -> (Print (Head m)); (Print (Head (Tail m)));
                             (Print (Head (Tail (Tail m)))); (Fun x -> x) In 
														
														
Let waitAck = Fun me -> y (Fun this -> Fun data -> Fun msg ->
                                    Match msg With
                                        `ack(n) -> If n = 3 Then (this data) Else
                                            ((data <- (`go(n+1))); 
                                            this data )
                               ) In 
Let testb = Fun me -> Fun dummy -> Fun msg0 ->
     Match msg0 With
		    `init(i) -> Let a2 = Create(waitAck, me) In 
						(me <- `go(1)); 
						   
            (y (Fun this -> Fun msg ->
               Match msg With `go(n) ->
                 (s <- `add(n,a2)); 
								 If n = 3 Then ((s <- `asList(me)); (testbcont)) Else this
            )) In 
				
				
    Let testa = Create(testb,0) In 
    testa <- `init(0);;



    [40 points]

--------------------------------------------------------------------------------------------------
  Section 3: Operational Equivalence
--------------------------------------------------------------------------------------------------


3. a. For each of the following Fb expressions, indicate whether operational equivalence
   holds. If it does not, show some context that evaluates differently dependent upon
   which of the two expressions you use. (Remember: it only takes one of the infinitely
   many contexts to make the two expressions operationally inequivalent).
   
   1. (Fun y -> Not y) False =~ True    Equivalence holds by def 2.25 (eval)
  
   2. y + x =~ x + y     Equivalence holds: Def 2.23 (sum) and Def 2.18 (trans)

   3. Fun f -> f 0 + f 1 =~ Fun f -> f 1 + f 0    Equivalence holds b/c in Fb f 0 is the same as some int v here, reduces to #2
  
   4. Let dummy = x y in (0 0) ~= (0 1)    Equivalence holds in Fb because no choice of x y will evaluate the left side: Lemma 2.7

   5. (Fun x -> x x)(Fun x -> x x) =~ (Fun x -> x x x)(Fun x -> x x x)  Equivalence holds because both never evaluate: Lemma 2.7


   b. As 3a. but for FbS. Think carefully about what stateful side effects could do.
	
	1. (Fun y -> Not y) False =~ True  Equivalence holds. I held in Fb and we can't get side effects to meddle in this evaluation.
  
   2. y + x =~ x + y   Equivalence holds: Post @223 on Piazza demonstrates that expressions don't commute, but post @220
	                      clarifies that x and y here are only variables, so no side effects contained within their evaluation.

   3. Fun f -> f 0 + f 1 =~ Fun f -> f 1 + f 0   Equivalence DOES NOT HOLD. The function f could reference a cell value that
	                                               affects how it behaves (like what type of argument it expects), and it can 
																								 change that value as a side effect in its application.
  
   4. Let dummy = x y in (0 0) ~= (0 1)      Equivalence holds. Side effects in x y cannot prevent (0,0) from being reached and failing to
	                                           evaluate (unless x y itself fails to evaluate, which is still equivalent).

   5. (Fun x -> x x)(Fun x -> x x) =~ (Fun x -> x x x)(Fun x -> x x x)  Equivalence holds. It did in Fb, and we can't get side effects to
	                                                                       meddle in the evaluation.

   c. As 3b. but for FbX.  Think carefully about what exception side effects could do. 
	
	1. (Fun y -> Not y) False =~ True     Equivalence holds, still a literal evaluation with no exceptions to meddle.
  
   2. y + x =~ x + y             Equivalence DOES NOT HOLD. y can be "Raise #Foo 1" while x is "Raise #Bar 2". First one reached matters.

   3. Fun f -> f 0 + f 1 =~ Fun f -> f 1 + f 0     Equivalence DOES NOT HOLD. The function f could just raise an exception dependent on
	                                                 its input. First one reached matters.
  
   4. Let dummy = x y in (0 0) ~= (0 1)             Equivalence DOES NOT HOLD. The evaluation of x y can raise an exception before the 
	                                                  inevaluable (0 0) is reached, such that the left term ould evaluate in some context
																										while the right one cannot.

   5. (Fun x -> x x)(Fun x -> x x) =~ (Fun x -> x x x)(Fun x -> x x x)    Equivalence holds. Neither can evaluate, Exceptions can't meddle.

   [35 points]

