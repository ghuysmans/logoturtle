type iter = int
type name = string
type param = string

type value =
  | VBool of bool
  | VFloat of float

type expr =
  | Var        of param
  | Bool       of bool
  | Number     of float
  | UnaryFunc  of param * expr
  | BinaryFunc of param * expr * expr
  | Plus       of expr * expr
  | Minus      of expr * expr
  | Times      of expr * expr
  | Divide     of expr * expr
  | Negate     of expr
  | Or         of expr * expr
  | And        of expr * expr
  | Not        of expr
  | Less       of expr * expr
  | Greater    of expr * expr
  | Equal      of expr * expr
  | NEqual     of expr * expr
  | LessEq     of expr * expr
  | GreaterEq  of expr * expr

type mapvalue =
  | Val       of value
  | UnaryVal  of (value -> value)
  | BinaryVal of (value -> value -> value)

type command =
  | Stop
  | Forward of expr
  | Back    of expr
  | Right   of expr
  | Left    of expr
  | Repeat  of expr * command list
  | Call    of name * expr list
  | Procdef of name * param list * command list
  | If      of expr * command list


(* prec  | operator  | operator
   level | character | name
   ==================================
       6 | - !       | unary minus, logical not
       5 | * /       | multiplication, division
       4 | + -       | addition, subtraction
       3 | < <= > >= | comparison operators
       2 | == !=     | equality operators
       1 | &&        | logical and
       0 | ||        | logical or

There are 8 levels of precedence.

*)



let string_of_expr e =
  let rec to_str n e =
    let (m, str) = match e with
      | Var name           -> (7, name)
      | Number n           -> (7, string_of_float n)
      | Bool  b            -> (7, string_of_bool b)
      | UnaryFunc (name, e) -> (7, name ^ "(" ^ (to_str 0 e) ^ ")")
      | BinaryFunc (name, e1, e2) -> (7, name ^ "(" ^ (to_str 0 e1) ^ " , " ^ (to_str 0 e2) ^ ")")
      | Negate e           -> (6, "-" ^ (to_str 0 e))
      | Not   b            -> (6, "!" ^ (to_str 0 b))
      | Times     (e1, e2) -> (5, (to_str 5 e1) ^ " * " ^ (to_str 6 e2))
      | Divide    (e1, e2) -> (5, (to_str 5 e1) ^ " / " ^ (to_str 6 e2))
      | Plus      (e1, e2) -> (4, (to_str 4 e1) ^ " + " ^ (to_str 5 e2))
      | Minus     (e1, e2) -> (4, (to_str 4 e1) ^ " - " ^ (to_str 5 e2))
      | Less      (e1, e2) -> (3, (to_str 3 e1) ^ " < " ^ (to_str 4 e2))
      | LessEq    (e1, e2) -> (3, (to_str 3 e1) ^ " <= " ^ (to_str 4 e2))
      | Greater   (e1, e2) -> (3, (to_str 3 e1) ^ " > " ^ (to_str 4 e2))
      | GreaterEq (e1, e2) -> (3, (to_str 3 e1) ^ " >= " ^ (to_str 4 e2))
      | Equal     (e1, e2) -> (2, (to_str 2 e1) ^ " == " ^ (to_str 3 e2))
      | NEqual    (e1, e2) -> (2, (to_str 2 e1) ^ " != " ^ (to_str 3 e2))
      | And       (b1, b2) -> (1, (to_str 1 b1) ^ " && " ^ (to_str 2 b2))
      | Or        (b1, b2) -> (0, (to_str 0 b1) ^ " || " ^ (to_str 1 b2))
    in
       if m < n then "(" ^ str ^ ")" else str
  in
     to_str (-1) e

let rec print_command cmd =
  match cmd with
    | Stop          -> print_string "stop "
    | Forward e     -> print_string ("forward " ^ (string_of_expr e) ^ " ")
    | Back    e     -> print_string ("back " ^ (string_of_expr e ) ^ " ")
    | Right   e     -> print_string ("right " ^ (string_of_expr e) ^ " ")
    | Left    e     -> print_string ("left  " ^ (string_of_expr e) ^ " ")
    | Repeat (e, cmd) ->
       print_string ("repeat " ^ (string_of_expr e) ^ " [ ");
       List.iter print_command cmd;
       print_string " ] "
    | Call (name, args) ->
       print_string (name ^ " " ^ (String.concat  " " (List.map string_of_expr args)) ^ " ")
    | Procdef (name, params, cmds) ->
       print_string ("to " ^ name ^
                       (String.concat " " (List.map (fun x -> ":" ^ x) params))
                         ^ "\n");
       List.iter print_command cmds;
       print_string "\nend\n"
    | If (e, cmds) ->
       print_string ("if " ^ (string_of_expr e) ^ " [ ");
       List.iter print_command cmds;
       print_string  " ]\n"

let rec print_commands cmds =
  match cmds with
    | [] -> ()
    | h :: t -> print_command h; print_commands t
