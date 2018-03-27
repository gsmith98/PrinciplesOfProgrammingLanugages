type 'a heap
val empty : unit -> 'a heap
val insert : 'a -> 'a heap -> 'a heap
val find_min : 'a heap -> ('a * 'a heap) option
val as_sorted_list : 'a heap -> 'a list
