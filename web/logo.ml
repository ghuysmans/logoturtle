open Lexing
open Logoturtle
module I = Interpreter.Make (Graphics)

module Html = Dom_html

let js = Js.string
let document = Html.window##.document

let append_text e s = Dom.appendChild e (document##(createTextNode (js s)))

let replace_child p n =
  Js.Opt.iter (p##.firstChild) (fun c -> Dom.removeChild p c);
  Dom.appendChild p n

exception SyntaxError of string

let print_position lexbuf =
  let pos = lexbuf.lex_curr_p in
  Printf.sprintf "%s:%d:%d" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | SyntaxError msg ->
     raise (SyntaxError ("Syntax error " ^ msg ^ (print_position lexbuf)))
  | Parser.Error ->
     raise (SyntaxError ("Parser error " ^ (print_position lexbuf)))

let parse_and_print lexbuf =
  Ast.print_commands (parse_with_error lexbuf)

let parse_print_and_eval lexbuf state =
  let ast_list = parse_with_error lexbuf in
  Ast.print_commands ast_list;
  print_string "\nnow evaling\n";
  ignore (I.eval_commands_return_state state ast_list);
  ""

let interpet _d state str = let lexbuf = Lexing.from_string str in
                            try parse_print_and_eval lexbuf state with
                              | SyntaxError msg -> msg
                              | I.ArgumentException msg -> msg
                              | I.RuntimeException msg -> msg
                              |  _ -> "unknown exception"

let div = Html.createDiv document

let start d s  _ = Dom.appendChild document##.body d;
                   Dom.appendChild d s.I.cr.Graphics.cr;
                   ignore (interpet d s "rt 360");
                   Js._false


let _ =
  let state = I.create_state in
  Html.window##.onload := Html.handler (start div state);
  Js.Unsafe.global##.printOCAMLString := Js.wrap_callback (fun s -> print_endline ("Hi " ^ (Js.to_string s)));
  Js.Unsafe.global##.interpetLOGO := Js.wrap_callback (fun s -> (js (interpet div state (Js.to_string s))))
