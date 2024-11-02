exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations


let rec first_then_apply 
    (lst : 'a list) 
    (p : 'a -> bool) 
    (f : 'a -> 'b option) 
    : 'b option =
  match lst with
  | [] -> None
  | head :: tail ->
      if p head then f head
      else first_then_apply tail p f 


let powers_generator (b : int) : int Seq.t =
  Seq.unfold (fun current_power -> Some (current_power, current_power * b)) 1

let meaningful_line_count (filename : string) : int =
  let ic = open_in filename in
  Fun.protect
    ~finally:(fun () -> close_in_noerr ic)
    (fun () ->
      let rec count acc =
        try
          let line = input_line ic in
          let trimmed = String.trim line in
          if trimmed = "" then
            count acc
          else if String.length trimmed > 0 && trimmed.[0] = '#' then
            count acc
          else
            count (acc + 1)
        with End_of_file ->
          acc
      in
      count 0
    )

type shape =
  | Sphere of float
  | Box of float * float * float

let volume (s : shape) : float =
  let pi = 4.0 *. atan 1.0 in
  match s with
  | Sphere r -> (4.0 /. 3.0) *. pi *. r *. r *. r
  | Box (l, w, h) -> l *. w *. h

let surface_area (s : shape) : float =
  let pi = 4.0 *. atan 1.0 in
  match s with
  | Sphere r -> 4.0 *. pi *. r *. r
  | Box (l, w, h) -> 2.0 *. (l *. w +. l *. h +. w *. h)

let to_string (s : shape) : string =
  match s with
  | Sphere r -> Printf.sprintf "Sphere(radius: %.2f)" r
  | Box (l, w, h) -> Printf.sprintf "Box(length: %.2f, width: %.2f, height: %.2f)" l w h

  
type 'a binary_search_tree = 
  | Empty 
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

let rec size tree = 
  match tree with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right;;

let rec contains value tree = 
  match tree with
  | Empty -> false
  | Node (left, v, right) ->
    if value = v then
      true 
    else if value < v then
      contains value left
    else
      contains value right;;

let rec inorder tree = 
  match tree with
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [v] @ inorder right;;

let rec insert value tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, v, right) ->
      if value < v then Node (insert value left, v, right)
      else if value > v then Node (left, v, insert value right)
      else tree;;
