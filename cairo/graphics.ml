open Cairo
type turtlecontext = { mutable cr: Cairo.context; }

let stroke ctx = Cairo.stroke ctx.cr
let set_source_rgb ctx r g b = Cairo.set_source_rgb ctx.cr ~r ~g ~b
let move_to ctx x y = Cairo.move_to ctx.cr ~x ~y
let line_to ctx x y = Cairo.line_to ctx.cr ~x ~y
let set_line_width ctx = Cairo.set_line_width ctx.cr

let create_context width height =
  let surface = Cairo.Image.create Cairo.Image.ARGB32 ~width ~height in
  let ctx = Cairo.create surface in
  let wf = float_of_int width in
  let hf = float_of_int height in
  (* paint background white *)
  Cairo.rectangle ctx ~x:0.0 ~y:0.0 ~w:wf ~h:hf;
  Cairo.set_source_rgb ctx ~r:1.0 ~g:1.0 ~b:1.0;
  Cairo.fill ctx;
  (* setup turtle coordinates *)
  Cairo.translate ctx ~x:(wf /. 2.0) ~y:(hf /. 2.0);
  Cairo.scale ctx ~x:2. ~y:2.;
  (* setup turtle line properties *)
  Cairo.set_line_width ctx 1.0;
  Cairo.set_source_rgb ctx ~r:0. ~g:0. ~b:0.;
  Cairo.set_line_join ctx JOIN_MITER;
  Cairo.set_line_cap ctx SQUARE;
  Cairo.move_to ctx ~x:0. ~y:0.;
  { cr = ctx; }



let write_out ctx filename = let surface = Cairo.get_target ctx.cr in
                             stroke ctx;
                             Cairo.PNG.write surface filename

(* These are nops for the cairographics backend *)
let remove_turtle _c = ()
let draw_turtle _c _x _y _h = ()
