open Lexer
open Lexing
open Printf
module I = Interpreter.Make (Cairographics)


let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)


let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | SyntaxError msg ->
     fprintf stderr "%a: %s\n" print_position lexbuf msg;
     exit (-1)
  | Parser.Error ->
     fprintf stderr "%a: syntax error\n" print_position lexbuf;
     exit (-1)

let rec parse_and_print lexbuf =
  Ast.print_commands (parse_with_error lexbuf)

let rec parse_print_and_eval lexbuf outfile =
  let ast_list = parse_with_error lexbuf in
  Ast.print_commands ast_list;
  print_string "\nnow evaling\n";
  I.eval_commands_to_file ast_list outfile

let basename filename =
  Filename.(remove_extension (basename filename))

let loop filename =
  let inx = open_in filename in
  let lexbuf = Lexing.from_channel inx in
  let outfile = basename filename ^ ".png" in
  print_string ("Writing output to " ^ outfile ^ "\n");
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  parse_print_and_eval lexbuf outfile;
  print_string "\n";
  close_in inx


open Cmdliner

let filename =
  let doc = "Logo script" in
  Arg.(required & pos 0 (some string) None & info [] ~doc ~docv:"SCRIPT")

let () =
  let cmd =
    let doc = "parse and interpet Logo" in
    Term.(const loop $ filename),
    Term.info "logo" ~doc ~version:"1.0"
  in
  Term.(exit @@ eval cmd)
