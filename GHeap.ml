type 'a heap = 'a list;;

let empty () : 'a heap = [];;

let insert x (xs : 'a heap) = (List.sort compare (x :: xs) : 'a heap);;

let find_min (xs : 'a heap) = match xs with | [] -> None | h :: t -> Some (h, (t : 'a heap));;

let as_sorted_list (xs : 'a heap) = (xs : 'a list);;