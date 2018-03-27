600.426 - Programming Languages
JHU Spring 2016
Homework 4 Part B (70 points)

--------------------------------------------------------------------------------------------------
HEADER: PLEASE FILL THIS IN
--------------------------------------------------------------------------------------------------

Name                  : Graham Smith
List of team Members  : Graham Smith
List of discussants   : Graham Smith

----------------------------------------------------------------------------------------
Section 1: Stateful Semantics
----------------------------------------------------------------------------------------

    In the presence of state, traditional looping constructs make sense once again. Let us
    introduce a new python style "While" loop to FbS, making a new language FbSW, with the
    following grammar:

    While e: e Else: e

    The behavior of an expression While e1: e2 Else: e3 is as follows:
      - As long as e1 evaluates to True, e2 gets evaluated repeatedly (as you would expect
        in most languages)
      - When e1 evaluates to False, e3 gets evaluated (once) instead.
      - The result of the while expression is the result of e3. The result of e2 is never
        really used. (This is different from Python since while in python does not return 
        a value.  But we like our values)

    E.g. Let t = Ref 0 in
         Let i = Ref 0 in
         While (Not (!i = 10)):
           t := !t + !i + 1 ;
           i := !i + 1
         Else:
           !t

        returns 55;

1a. As a warm-up, write out the FbS rules for evaluating If-Then-Else.  The book does not
    present a full rule set for FbS, but shows application and a few other rules that you
    can base it on.
    
		If True rule:
		
		<e1, S1> => <True, S2>, <e2, S2> => <v2, S3>
		__________________________
		<If e1 Then e2 Else e3, S1> => <v2, S3>
		
		
		If False rule:
	  <e1, S1> => <False, S2>, <e3, S2> => <v3, S3>
		__________________________
		<If e1 Then e2 Else e3, S1> => <v3, S3>
		
		
		
1b. Write down the operational semantics for the above While expression as an extension to
    FbS.
    
		While False rule (base case):
	
		<e1, S1> => <False, S2>, <e3, S2> => <v3, S3>
		__________________________
		<While e1: e2 Else: e3, S1> => <v3, S3>
		
		
		While True rule (recursive):
		
		<e1, S1> => <True, S2>, <e2, S2> => <v3, S3>, <While e1: e2 Else: e3, S3> => <v4, S4>
		_____________________________________________
		<While e1: e2 Else: e3, S1> => <v4, S4>
		
		
		
    [15 Points]


----------------------------------------------------------------------------------------
Section 2: Extensible Records
----------------------------------------------------------------------------------------

2a. We covered the operational semantics of pairs in lecture, but not records.  For this
question, present the operational semantics rules needed for FbR.  First write out the new
expressions and values to add to Fb, then the new values, and finally the operational
semantics rules.  The book contains a sketch of an interpreter for FbR, but we want
operational semantics rules, not an interpreter.


l is a metavariable for a label, and label is a new value
Record is a new value
Select is a new expression

(It's possible I'm supposed to add a trivial rule for evaluating labels and include it several times 
in the numerator of all other rules in 2a/2b, but I have not done this for simplicity's sake.)

Record Creation Rule (/ Value Rule):

e1 => v1, e2 => v2, ... , en => vn
__________________________________
{ l1=e1; l2=e2; ... ln=en } => { l1=v1; l2=v2; ... ln=vn }

Select Rule:

e1 => { l1=v1; l2=v2; ... lq=vq; ... lv=vn }
___________________________________
           e1.lq => vq



2b. Consider a new language FbxR - Fb with extensible Records. Extensible records are like
normal FbR, but they can also be FU   NCTIONALLY extended - you can define a new record with
one extra field.  Other than the new extension operator, records work just like in FbR.

Example:
 
    Let r = { x = 3 + 4 ; y = (Function a -> a + 1) ; } In
    Let rnew = r.z <+ True In
      rnew.z (* returns True; note r.z would be a runtime error, r still has no z *)

     (Let in the above is a macros with the usual meaning)

If you extend a field that already exists, it is an override:

    Let r = { x = 3 + 4 ; y = (Function a -> a + 1) ; } In
    Let rnew = r.x <+ True In
      rnew.x (* returns True *)

    The value and expression syntax of FbR will need to be extended to accomodate 
    the new syntax for mutable records. You must provide these extensions along with the
    set of new operational semantics rules required for FbxR.  Since you gave the
    operational semantics of FbR in question 2a, here you only need to add the syntax
    and semantics for the extension operator.



<+ Override Rule:

e1 => { l1=v1; l2=v2; ... lq=vq; ... ln=vn }, e2 => vnew
_____________________________________________________________
e1.lq <+ e2 => { l1=v1; l2=v2; ... lq=vnew; ... ln=vn }

<+ Extend Rule:

e1 => { l1=v1; l2=v2; ... ln=vn } with no label lq, e2 => vnew
_____________________________________________________________
e1.lq <+ e2 => { l1=v1; l2=v2; ... ln=vn; lq=vq }


    [25 Points]


----------------------------------------------------------------------------------------
Section 3: Inheritance With Extensible Records
----------------------------------------------------------------------------------------

3a.  In the encoding of inheritance in the book section 5.1.5, it was required to
explicitly copy over all inherited fields and methods one by one.  For this question,
re-do the colorPointClass definition in that section using FbSxR (FbSR plus the <+
operator in question 2b above) so that this explicit copying is not needed, only the new
and overridden fields/methods need to be added.

Let pointClass = . . . In
  Let colorPointClass = Function _ ->
    Let super = pointClass {} In {
      (((super
			).color <+ Ref {red = 45; green = 20; blue = 20}
			).magnitude <+ Function this -> Function -> mult(super.magnitude this {})(this.brightness this {}
			).brightness <+ Function this -> Function -> (* compute brightness. . . *) 
    } In . . .


3b. It is also possible to write higher-order class operations using record extension.
Write a FbSxR function addPulse which takes a FbSxR class such as pointClass or
colorPointClass from the book Section 5.1.5 (or any other class encoded in that manner)
and adds a boolean field pulse (initially False), methods pulseOn and pulseOff which
change the pulse setting, and override magnitude so it is 0 if the pulse is off, otherwise
it is the same behavior as it was.

Example:
     Let addPulse = Fun aClass -> 
		   Function _ -> 
				Let super = aClass {} In
				  ((((super
					).pulse <+ False 
		      ).pulseOn <+ Function this -> Function _ -> this.pulse := True
		      ).pulseOff <+ Function this -> Function _ -> this.pulse := False
		      ).magnitude <+ Function this -> Function _ -> If this.pulse Then super.magnitude this {} Else 0
		 In
     Let pulsedPointClass = addPulse pointClass In
        Let ppOb = pulsedPointClass {} In
          ppOb.magnitude ppOb {} (* should return 0 in spite of x,y being (4,3) *)

And, the code should produce the same answer for colorPointClass as well.

[15 points ]


----------------------------------------------------------------------------------------
Section 4: Exceptions
----------------------------------------------------------------------------------------

4. As with State, the FbX extension for exceptions requires that the old rules be changed.
Suppose we were to add the Implies operator of our toy BOOL language to FbX, giving new
language FbXI.  For this question, write out ALL the rules needed for logical Implies in
the full FbX rule set.  The hard part is all of the "bubbling" rules needed for bubbing up
exceptions; we described several rules needed for + in lecture and the book has one rule
needed for -.  Think carefully about all the places the program could "blow up" in
computing a binary operator.

[15 points]