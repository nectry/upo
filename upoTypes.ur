type richtext = string
val show_richtext = _
val read_richtext = _
val eq_richtext = _
val ord_richtext = _
val inj_richtext = _
val widget_richtext = Widget.htmlbox
val explorer_richtext = @@Explorer.htmlbox
type richtextInBody_cfg = _
type richtextInBody_st = _
val richtextInBody = @@SmartList.htmlInBody
type richtext_cfg = _
type richtext_st = _
val richtext = @@SmartTable.html

(* REFACTOR: This exact same code is being used in widget.ur.  So, widget.ur
really wants to depend on this module for rich text conversion (and it should be
using `render` for `AsValue` too!), but this module wants to depend on
`widget.ur` so that it can easily declare a `widget` instance based on the
`Widget.htmlbox`, which can only be done trivially here because within this
module, `richtext` is just `string`. *)
val tags = (Html.b, Html.i, Html.a, Html.strong, Html.em, Html.p, Html.div, Html.br, Html.code, Html.tt, Html.ol, Html.ul, Html.li)
fun richTextToHtml (rt : richtext) : xbody =
    case Html.format tags rt of
        Html.Failure msg => <xml><b>HTML error: {[msg]}</b></xml>
      | Html.Success xm => xm

fun richTextToPlain (rt : richtext) : string =
    case Html.formatPlainText tags rt of
        Html.Failure msg => "HTML error: " ^ msg
      | Html.Success txt => txt

con render t = t -> xbody
fun render [t] (r : render t) (t : t) = r t

fun mkRender [t] f = f
val render_int = txt
val render_float = txt
val render_money = txt
val render_string = txt
val render_char = txt
val render_bool = txt
fun render_time t = if t = minTime then <xml><b>INVALID</b></xml> else txt t
val render_richtext = richTextToHtml
fun render_unit () = txt "()"
fun render_option [t] r o = case o of
    Some t => r t
  | None => <xml/>
val render_list [t] r =
  let
    fun render' (ls : list t) =
      case ls of
        [] => <xml>[]</xml>
      | x :: ls => <xml>{r x} :: {render' ls}</xml>
  in
    render'
  end

