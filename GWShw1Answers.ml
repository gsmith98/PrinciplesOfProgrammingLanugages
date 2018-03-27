(*
  600.426 - Programming Languages
  JHU Spring 2016
  Homework 1

  In this source file, you will find a number of comments containing the text
  "ANSWER".  Each of these comments indicates a portion of the source code you
  must fill in yourself.  Read the instructions for each problem and supply a
  segment of code which accomplishes the indicated task.  For your convenience,
  a number of test expressions are provided for each problem as well as a
  description of their expected values.

  Please also fill in the HEADER section right below this one.

  Please note that you are NOT permitted to use any OCaml module functions (such
  as List.length) to complete this assignment unless it is explicitly specified in the
  question. You are also not permitted to make use of mutation (references, arrays, etc.).
  On the other hand you are encouraged to write additional helper functions and reuse earlier
  functions in the file.

  Make sure to eliminate compiler/interpreter warnings before submitting your code.

*)

(* -------------------------------------------------------------------------------------------------- *)
(* HEADER: PLEASE FILL THIS IN                                                                        *)
(* -------------------------------------------------------------------------------------------------- *)

(*

  Name                        : Graham Smith
  List of team Members        : Graham Smith (solo)
  List of other collaborators : Graham Smith (solo)

*)

(* -------------------------------------------------------------------------------------------------- *)
(* Section 1 : A list of list functions                                                               *)
(* -------------------------------------------------------------------------------------------------- *)

(* Some helper functions *)

let pair x y = (x, y);;

(*
  1a. To warmup, write a function that takes two lists and returns their
      elements paired up. If the lists are different lengths, it truncates the
      longer one.

      [3 Points]
*)

let rec zip xs ys = 
	match xs, ys with 
		  _, [] -> []
		| [], _ -> []
		| xshead :: xstail, yshead :: ystail -> (xshead, yshead) :: zip xstail ystail;; (* ANSWER *)

(*
# zip [1;2;3] [4;5;6] ;;
- : (int * int) list = [(1, 4); (2, 5); (3, 6)]
# zip ["a";"b"] [4;5;6] ;;
- : (string * int) list = [("a", 4); ("b", 5)]
*)

(*
  1b. Now modify the function so that it takes a parameter for how to combine
      the lists.

      [5 Points]
*)

let rec zipWith f xs ys = 
	match xs, ys with 
		  _, [] -> []
		| [], _ -> []
		| xshead :: xstail, yshead :: ystail -> (f xshead yshead) :: zipWith f xstail ystail;; (* ANSWER *)

(* HINT: `zipWith pair` should behave like `zip` on all inputs. *)

(*
# zipWith (+) [1;2;3] [4;5;6] ;;
- : int list = [5; 7; 9]
# zipWith ( * ) [1;2;3] [4;5;6] ;;
- : int list = [4; 10; 18]
# zipWith (fun x -> fun y -> x *. (float_of_int y)) [1.1; 2.2; 3.4] [2; 4; 6] ;;
- : float list = [2.2; 8.8; 20.4]
# zipWith ( fun x -> fun y -> (string_of_int x) ^ "-" ^ (string_of_int y) ) [0xa] [0xc] ;;
- : string list = ["10-12"]
*)

(*
  1c. Write a function `split` that takes a parameter `n` and a list and
      returns a pair of lists where the first element consists of the first n
      values from the source list and the second element is the remainder of that
      list.  If n is greater than the length of the list, the first list should
      contain the entire source list and the second list should be empty.

      You can assume that n >= 0.

      [5 Points]
*)

let rec split n lst = 
	let rec splithelper n tupoftwolists = match n, tupoftwolists with 
		  0, (x,y) -> (x,y)
		|	n, (x, []) -> (x, [])
		| n, (frontlist, backlisthead :: backlisttail) -> splithelper (n-1) (frontlist @ [backlisthead], backlisttail) 
		in
			splithelper n ([], lst);;  (* ANSWER *)

(*
# split 3 [1;2;3;4;5;6;7;8;9] ;;
- : int list * int list = ([1; 2; 3], [4; 5; 6; 7; 8; 9])
# split 3 [1;2] ;;
- : int list * int list = ([1; 2], [])
*)


(*
  1d. Write a function to sum a non-empty list of integers. You may throw an
      exception of the list is empty, or you may return zero. You can use the
      "invalid_arg" function from Pervasives for this.

      [3 Points]
*)

let rec sum xs = match xs with
		  [] -> 0
		| x :: rest -> x + sum rest;; (* ANSWER *)

(*
# sum [1;2;3;4];;
- : int = 10
*)

(*
  1e. Generalize `sum` to take an argument of how to combine the elements. If
      the list is empty, raise an exception. You can use the "invalid_arg"
      function from Pervasives for this.

      [5 Points]
*)

let rec reduce f xs = match xs with
		  [] -> invalid_arg "Cannot reduce an empty list"
		| x :: [] -> x
		| x :: last :: [] -> f x last 	
		| x :: rest -> f x (reduce f rest);; (* ANSWER *)

(*
# reduce (+) [1;2;3;4];;
- : int = 10
# reduce ( * ) [1;2;3;4];;
- : int = 24
# reduce (^) ["1";"2";"3";"4"];;
- : string = "1234"
*)

(*
  1f. In linear algebra, the dot product is the sum of the element-wise product
      of two vectors. Write a function which takes two lists and computes their
      "dot product". If the two lists are of different lengths, you may
      truncate the longer one or throw an exception.

      HINT: You should be able to use functions you've defined previously to
      avoid having to pattern match or recurse.

      [3 Points]
*)

let rec dot_product xs ys = reduce (+) (zipWith ( * ) xs ys);; (* ANSWER *)

(*
# dot_product [1;2;3] [4;5;6];;
- : int = 32
*)

(*
  1g. Generalize dot_product so that it takes an "addition" function and a
      "multiplication" function as parameters

      [5 Points]
*)

let rec g_dot_product add mul xs ys = reduce add (zipWith mul xs ys);; (* ANSWER *)

(*
# g_dot_product (+) ( * ) [1;2;3] [4;5;6];;
- : int = 32
# g_dot_product (+.) ( fun x y -> float_of_int x *. y ) [1;2;3] [4.;5.;6.];;
- : float = 32.
*)

(* -------------------------------------------------------------------------------------------------- *)
(* Section 2: A list of list of list functions                                                        *)
(* -------------------------------------------------------------------------------------------------- *)

(*
  2a. Write a function which calculates the dimensions of a list of lists. If
      not all of the inner lists are the same length, throw an exception. You
      may use List.length for this.

      [5 Points]
*)

let rec dimensions xss = (if xss = [] then (0,0) 
		else (List.length xss, reduce (fun x -> fun y -> (if (x = y) then x else invalid_arg "")) (List.map List.length xss))) ;; (* ANSWER *)
		(* I figured using List.map was okay since I could also have just copied the identical map definition from lecture *)

(*
# dimensions [[1;2;3];[4;5;6]];;
- : int * int = (2, 3)
# dimensions [[1;2;3];[4;5;6;7]];;
Exception: Invalid_argument "".
# dimensions [[];[]];;
- : int * int = (2, 0)
# dimensions [];;
- : int * int = (0, 0)
*)

(*
  2b. Write a function which chunks a list; that is, it takes an positive
      integer as its first parameter and a list as its second, returning a list
      of lists of that length in order. If the list does not divide evenly, you
      may discard the remainder, keep it, or throw and exception.

      HINTS:
        You probably want to use `split` from 1c.
        The following code should return true no matter what you pass it:

            (fun n xs ->
                if List.length xs mod n = 0
                then let cs = chunk n xs in
                     dimensions cs ;
                     List.flatten cs = xs
                else true)

      [8 Points]
*)

let rec chunk n xs = match split n xs with
		 (x,[]) -> [x]
	|  (x, y) -> x :: chunk n y;; (* ANSWER *)

(*
# chunk 3 [1;2;3;4;5;6;7;8;9];;
- : int list list = [[1; 2; 3]; [4; 5; 6]; [7; 8; 9]]
# chunk 2 [1;2;3;4;5;6;7;8];;
- : int list list = [[1; 2]; [3; 4]; [5; 6]; [7; 8]]
# chunk 4 [1;2;3;4;5;6;7;8];;
- : int list list = [[1; 2; 3; 4]; [5; 6; 7; 8]]
*)

(*
  2c. Write a function which transposes a list of lists; that is to say that
      the first elements of all the lists form the first list, the second
      elements form the second list, etc.

      HINT:
        The following code should return true or throw an exception no matter
        what you pass it:

            (fun xs ->
                let ts = transpose xs in
                let (r,c) = dimensions xs in
                if r <> 0 && c <> 0
                then (dimensions ts = (c,r)) &&
                     (transpose ts = xs)
                else true)

      [8 Points]
*)

let rec transpose xss = reduce (zipWith (@)) (List.map (chunk 1) xss);; (* ANSWER *)

(*
# transpose [[1; 2; 3]; [4; 5; 6]; [7; 8; 9]];;
- : int list list = [[1; 4; 7]; [2; 5; 8]; [3; 6; 9]]
# transpose [[1; 2; 3; 4]; [5; 6; 7; 8]];;
- : int list list = [[1; 5]; [2; 6]; [3; 7]; [4; 8]]
# transpose [[1; 2]; [3; 4]; [5; 6]; [7; 8]];;
- : int list list = [[1; 3; 5; 7]; [2; 4; 6; 8]]
*)

(* -------------------------------------------------------------------------------------------------- *)
(* Section 3 : The Matrix                                                                             *)
(* -------------------------------------------------------------------------------------------------- *)

(* In this section, we will be representing matricies as lists of lists of
   elements; if you need to remind yourself of some of the concepts in this
   section, the Wikipedia page for on matrix multiplication is a good
   reference.
   
   https://en.wikipedia.org/wiki/Matrix_multiplication
*)

(*
  3a. Write a function that produces the identity matrix of a given size.

      [2 Points]
*)

let rec identity_matrix n =
		let rec identity_helper n j donen =
				match n, j, donen with
				| n, 0, donen -> [1] @ identity_helper n n (donen+1)
				| n, j, donen -> if (donen = n) then [] else [0] @ identity_helper n (j-1) donen
			in
			chunk n (identity_helper n 0 0);;
		
(*	
# identity_matrix 1;;
- : int list list = [[1]]
# identity_matrix 3;;
- : int list list = [[1; 0; 0]; [0; 1; 0]; [0; 0; 1]]
*)

(*
  3b. Generalize the above function to take as arguments what it should use for
      the matrix zero and one.

      [5 Points]
*)

let rec g_identity_matrix zero one n = 
		let rec identity_helper n j donen =
				match n, j, donen with
				| n, 0, donen -> [one] @ identity_helper n n (donen+1)
				| n, j, donen -> if (donen = n) then [] else [zero] @ identity_helper n (j-1) donen
			in
			chunk n (identity_helper n 0 0);; (* ANSWER *)

(*
# g_identity_matrix 0 1 3;;
- : int list list = [[1; 0; 0]; [0; 1; 0]; [0; 0; 1]]
# g_identity_matrix "0" "1" 2;;
- : int list list = [["1"; "0"]; ["0"; "1";]
*)

(*
  3c. Write a function that will multiply two matricies (represented as lists
      of lists); you may throw an exception if they matricies have incompatible
      dimensions or you may return a nonsensical (but still type-correct)
      answer.

      HINT: You might want to use `transpose` and `dot_product`

      [3 Points]
*)

let rec matrix_multiply xss yss = 
		let rec iterateovercolumns xsshead yss =
			match yss with 
			| [] -> invalid_arg "trying to multiply empty matrix"
			| ysshead :: [] -> [dot_product xsshead ysshead]
			| ysshead :: ysstail -> [dot_product xsshead ysshead] @ (iterateovercolumns xsshead ysstail) 
		in
			let rec iterateoverrows xss yss =
				match xss with
				| [] -> invalid_arg "trying to multiply empty matrix"
				| xsshead :: [] -> iterateovercolumns xsshead yss :: []
				| xsshead :: xsstail -> (iterateovercolumns xsshead yss) :: (iterateoverrows xsstail yss)
			in
				iterateoverrows xss (transpose yss);; (* ANSWER *)
	
	
(*
# matrix_multiply (identity_matrix 3) (identity_matrix 3);;
- : int list list = [[1; 0; 0]; [0; 1; 0]; [0; 0; 1]]
# matrix_multiply [[1;2;3];[4;5;6]] [[7;8];[9;10];[11;12]];;
- : int list list = [[58; 64]; [139; 154]]
*)

(*
  3d. Generalize the above to take the "addition" and "multiplication"
      functions as parameters.

      HINT: You might want to use `transpose` and `g_dot_product`

      [7 Points]
*)

let rec g_matrix_multiply plus times xss yss = 
		let rec iterateovercolumns xsshead yss =
			match yss with 
			| [] -> invalid_arg "trying to multiply empty matrix"
			| ysshead :: [] -> [g_dot_product plus times xsshead ysshead]
			| ysshead :: ysstail -> [g_dot_product plus times xsshead ysshead] @ (iterateovercolumns xsshead ysstail) 
		in
			let rec iterateoverrows xss yss =
				match xss with
				| [] -> invalid_arg "trying to multiply empty matrix"
				| xsshead :: [] -> iterateovercolumns xsshead yss :: []
				| xsshead :: xsstail -> (iterateovercolumns xsshead yss) :: (iterateoverrows xsstail yss)
			in
				iterateoverrows xss (transpose yss);; (* ANSWER *)

(*
# g_matrix_multiply (+) ( * )
  [[1; 2; 3];
   [4; 5; 6]]

  [[7;  8 ];
   [9;  10];
   [11; 12]];;
- : int list list = [[58; 64]; [139; 154]]

# g_matrix_multiply (fun x y -> (x || y) && (not (x && y))) (&&)
  [[true; false; true];
   [true; true;  false]]

  [[true;  true];
   [true;  true];
   [false; true]];;
- : bool list list = [[true; false]; [false; false]]
*)


(* -------------------------------------------------------------------------------------------------- *)
(* Section 4 : Sudoku Verifier                                                                        *)
(* -------------------------------------------------------------------------------------------------- *)

(*
  For this question we will build a simple sudoku checker. The final goal is to write a function that
  when presented with a sudoku grid, returns whether it has been solved or not. In case you are not familiar
  with the puzzle, you can read about it here: https://en.wikipedia.org/wiki/Sudoku.

  A filled grid looks like this (courtesy wikipedia):
  https://en.wikipedia.org/wiki/Sudoku#mediaviewer/File:Sudoku-by-L2G-20050714_solution.svg

  To verify a grid, we have to check that each row, each column and each of the (bolded) 3x3 regions are
  some permutation of the sequence 1, 2, ..., 9. We will build the machinery for this piece-by-piece

  A straight forward way to represent a sudoku grid is as a list of 9 rows, each of which is also a list of
  9 integers.

  Here are a few grids for testing purposes:

  # let solved_grid_1 = [[5;3;4;6;7;8;9;1;2]; [6;7;2;1;9;5;3;4;8]; [1;9;8;3;4;2;5;6;7];
                         [8;5;9;7;6;1;4;2;3]; [4;2;6;8;5;3;7;9;1]; [7;1;3;9;2;4;8;5;6];
                         [9;6;1;5;3;7;2;8;4]; [2;8;7;4;1;9;6;3;5]; [3;4;5;2;8;6;1;7;9]] ;;

  # let solved_grid_2 = [[2;4;6;8;5;7;9;1;3]; [1;8;9;6;4;3;2;7;5]; [5;7;3;2;9;1;4;8;6];
                         [4;1;8;3;2;9;5;6;7]; [6;3;7;4;8;5;1;2;9]; [9;5;2;1;7;6;3;4;8];
                         [7;6;4;5;3;2;8;9;1]; [3;2;1;9;6;8;7;5;4]; [8;9;5;7;1;4;6;3;2]] ;;

  # let unsolved_grid = [[1;9;4;2;8;6;7;3;5]; [8;3;7;5;9;4;2;1;6]; [6;2;5;3;5;7;8;9;4];
                         [7;4;3;9;4;8;1;6;2]; [2;5;1;6;5;3;9;4;8]; [9;8;6;1;7;2;3;5;7];
                         [5;6;2;8;3;1;4;7;9]; [4;1;9;7;2;5;6;8;3]; [3;7;8;4;6;9;5;2;1]] ;;

  Hint: You have already written many functions in other sections that can come in handy here. Also be sure to glance
        at the lecture notes for even more useful functions.
*)

(*
  4a. With the list-of-lists arrangement, it is easy to access rows from the grid. Columns are a bit harder. For
      this question, write a function that when given a column index (zero-based) and a grid, extracts the specific
      column.

      [8 Points]
*)

let rec nth l n = 
  		match l with
    		[] -> failwith "Could not find"
  			| x :: xs -> if n = 0 then x else nth xs (n - 1);; (* Taken from lecture code. Will be used to grab specific row/column/grid *)

let rec fetch_column grid col = nth (transpose grid) col;; (* ANSWER *)

(*
# fetch_column solved_grid_1 4 ;;
- : int list = [7; 9; 4; 6; 5; 2; 3; 1; 8]
# fetch_column solved_grid_2 7 ;;
- : int list = [1; 7; 8; 6; 2; 4; 9; 5; 3]
*)

(*
  4b. Now write a function, given a starting row, starting column, a row count and column count, extracts the
      specified subsection of grid as a single list in row-major order.

      [10 Points]
*)

let rec fetch_grid grid start_row start_col row_count col_count = 
	let range list a b = (fun (x,y) -> x) (split b ((fun (x,y) -> y) (split a list))) in
		if row_count = 0 then [] else 
			(range (nth grid start_row) start_col col_count) @ fetch_grid grid (start_row+1) start_col (row_count-1) col_count;; (* ANSWER *)

(*
# fetch_grid solved_grid_1 3 6 3 3  ;;
- : int list = [4; 2; 3; 7; 9; 1; 8; 5; 6]
# fetch_grid solved_grid_2 6 0 3 3 ;;
- : int list = [7; 6; 4; 3; 2; 1; 8; 9; 5]
*)

(*
  4c. Write a predicate function that, given a list, verifies that it is some permutation of the sequence:
      1, 2, ..., 9

      [5 Points]
*)

let rec verify_list lst = 
  let rec check list one two three four five six seven eight nine =
  	match list with 
  	| [] ->   one && two && three && four && five && six && seven && eight && nine
  	|  1 :: tail -> check tail true two three four five six seven eight nine
  	|  2 :: tail -> check tail one true three four five six seven eight nine
  	|  3 :: tail -> check tail one two true four five six seven eight nine
  	|  4 :: tail -> check tail one two three true five six seven eight nine
  	|  5 :: tail -> check tail one two three four true six seven eight nine
  	|  6 :: tail -> check tail one two three four five true seven eight nine
  	|  7 :: tail -> check tail one two three four five six true eight nine
  	|  8 :: tail -> check tail one two three four five six seven true nine
  	|  9 :: tail -> check tail one two three four five six seven eight true
		|  x :: tail -> false
	in
	(List.length lst = 9) && (check lst false false false false false false false false false);; (* ANSWER *)

(*
# verify_list [4; 2; 3; 7; 9; 1; 8; 5; 6] ;;
- : bool = true
# verify_list [8; 9; 5; 4; 5; 7; 3; 2; 6] ;;
- : bool = false
*)

(*
  4d. Finally write a function that checks whether a given sudoku grid has been solved or not

      [10 Points]
*)

let rec verify_grid grid = 
	verify_list (nth grid 0) &&
	verify_list (nth grid 1) &&
	verify_list (nth grid 2) &&
	verify_list (nth grid 3) &&
	verify_list (nth grid 4) &&
	verify_list (nth grid 5) &&
	verify_list (nth grid 6) &&
	verify_list (nth grid 7) &&
	verify_list (nth grid 8) &&
	verify_list (fetch_column grid 0) &&
	verify_list (fetch_column grid 1) &&
	verify_list (fetch_column grid 2) &&
	verify_list (fetch_column grid 3) &&
	verify_list (fetch_column grid 4) &&
	verify_list (fetch_column grid 5) &&
	verify_list (fetch_column grid 6) &&
	verify_list (fetch_column grid 7) &&
	verify_list (fetch_column grid 8) &&
	verify_list (fetch_grid grid 0 0 3 3) &&
	verify_list (fetch_grid grid 0 3 3 3) &&
	verify_list (fetch_grid grid 0 6 3 3) &&
	verify_list (fetch_grid grid 3 0 3 3) &&
	verify_list (fetch_grid grid 3 3 3 3) &&
	verify_list (fetch_grid grid 3 6 3 3) &&
	verify_list (fetch_grid grid 6 0 3 3) &&
	verify_list (fetch_grid grid 6 3 3 3) &&
	verify_list (fetch_grid grid 6 6 3 3);; (* ANSWER *)

(*
# verify_grid solved_grid_1 ;;
- : bool = true
# verify_grid solved_grid_2 ;;
- : bool = true
# verify_grid unsolved_grid ;;
- : bool = false
*)