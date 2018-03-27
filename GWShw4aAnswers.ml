600.426 - Programming Languages
JHU Spring 2016
Homework 4 Part A (30 points)

--------------------------------------------------------------------------------------------------
HEADER: PLEASE FILL THIS IN
--------------------------------------------------------------------------------------------------

Name                  : Graham Smith
List of team Members  : Graham Smith (solo)
List of discussants   : Graham Smith (solo)

--------------------------------------------------------------------------------------------------
   Variants
--------------------------------------------------------------------------------------------------


1. We observed in lecture that the FbV Match operational semantics rule was not completely accurate: if two clauses matched it would not pick the first one like it should.  For example, 

Match `Some(3 - 7) With `Some(x) -> 0 | `Some(x) -> 1 ==> 1

could be proved.

a. For a warm-up, write a full proof tree concluding in the above.  The proof rules for FbV are on page 56 of the book.


3=>3 7=>7
_______
3-7=>4                                1=>1
___________________                 __________
Some(3-7)=>Some(4)                  1[-4/x]=>1     
______________________________________________________________________________
Match `Some(3 - 7) With `Some(x) -> 0 | `Some(x) -> 1 ==> 1

b. Prove that ==> for FbV as defined in the book is nondeterministic (the definition of deterministic is in the book, and nondeterministic is its negation).

Match `Some(3 - 7) With `Some(x) -> 0 | `Some(x) -> 1 ==> 0 because:


3=>3 7=>7
_______
3-7=>4                                0=>0
___________________                 __________
Some(3-7)=>Some(4)                  0[-4/x]=>0     
______________________________________________________________________________
Match `Some(3 - 7) With `Some(x) -> 0 | `Some(x) -> 1 ==> 1

Since e=>1 and e=>0 and 1!=0, then FbV must not be deterministic as defined in the book.



c. Fix the rule to pick the first clause only.  Remember the rules are mathematical definitions and any side-conditions necessary can be added.

e=> nj(vj),  e=/=> nk(vk) for any k<j,  ej[vj,xj]=>v   
____________________________________________
Match e With
   n1(x1) -> e1 | ...
	 nj(xj) -> ej | ...  => v
	 nm(xm) -> em

[10 points]

--------------------------------------------------------------------------------------------------
  State and Recursion
--------------------------------------------------------------------------------------------------

2. Section 4.1.2 discusses cyclical stores.  We did not cover that topic in lecture so you probably want to quickly review that section now.  The main example is

Let y = Ref 0 In
Let _ = y := (Function x -> If x = 0 Then 0 Else x + (!y)(x-1))
In (!y)(10);;

Which is an Fb program computing 1+...+10 *without* any self-passing.  But, it still has self-reference, the contents of the cell y refer to y itself.  You can run this program in the FbSR interpreter we supply in the binary distribution, just type "ocamlrun fbsr.byte" and paste in the above (note the example in the book was not exactly in the FbSR syntax but the above is and you can run it; FbSR has Let along with records and state).


a. If we changed the 10 above to -10 (well,. 0-10 in our cheesy parser) we would get a diverging program, it would never hit the base case (try it in the FbSR interpreter if you are not believing).  For this question write a reallly small program which captures the essence of this divergence - the conditional and base case for example are not needed.  Simplify out everything you can but run it to make sure it still diverges.

Let y = Ref 0 In Let _ = y := (Function x -> (!y) x) In (!y) 0;;


b. You want to make your answer to 2a as short as you can, because for this question you are to write out the FbS operational semantics *proof tree* which shows your program in 2a will run forever.  Your answer should use the proof rules for FbS in the book Section 4.1.1.  Some example FbS proofs are given in Examples 4.1 and 4.2.  Your proof tree will never finish, similarly to (Fun x -> x x)(Fun x -> x x) -- just get it to the point where its obvious it will not finish.  Note that FbS has no Let syntax in it, so as your first step convert your answer to 3a into a Let-free form using the macro definition of Let in the book.  Values that compute to themselves you can leave out of your tree for simplicity if you want.

An equivalent way of writing 3a is:
(Function y -> ((Function e -> (!y) 0) (y := Function x -> (!y) x))) (Ref 0);;
Here I've elipsed out parts of the proof that don't immediately impact demonstrating the divergence.

                                                                                                                                                                               Repeating                                     
                                                                                                                                                                             _________________                                                 
                                                                                                                         ...                                                <(!y) 0,S5> => ???                                  
                                                                                                               ________________________________________                   __________________________
                                                                     ...                ...                    <(!y),S5> => <Function x -> (!y) x, S5>,  <0,S5>=><0,S5>,  <(!y) x[0/x], S5> => ???          
                                                                ___________________________________________       _________________________________________________________________________________
                                             ...S3->S4...      <(y := Function x -> (!y) x),S4> => <...,S5>         <(!y) 0,S5> => ???                               
                                            ________________________________________________________________________________________
    ...S1-->S2...          ...S2->S3...       <((Function e -> (!y) 0) (y := Function x -> (!y) x))[Ref 3/y], S3> => ??? 
_______________________________________________________________________________________________________________________________
<(Function y -> ((Function e -> (!y) 0) (y := Function x -> (!y) x))) (Ref 0) , S1> => ???

c. Now, going back to the example above, use it as inspiration to make a new form of Y combinator ysComb which is a stateful Y combinator.  The test case is the same as yComb:

Let ysComb = (Function body -> Function arg ->
	Let y = Ref 0 In 
	Let _ = y := (Function arg -> (body (!y) arg)) In 
	(!y) arg 
)
In ysComb (Function self -> Function x -> If x = 0 Then 0 Else x + self (x-1)) 5 ;;

should return 15.

Hint: like we did in lecture, turn the summate code block into a parameter you pass in as a function; make any variables in the summate code block be parameters to this function.

You are not allowed to use any function self passing ("x x" kind of thing), all the self-reference must be through the heap to get credit for the problem. 

[20 points]