(* Richtext is a way to hold information about formatted text *)
type richtext
(* The simple show instance returns a string that looks like xml.  The `read`
instance is the inverse of this. *)
val show_richtext : show richtext
val read_richtext : read richtext
val eq_richtext : eq richtext
val ord_richtext : ord richtext
val inj_richtext : sql_injectable_prim richtext
val widget_richtext : Widget.t richtext Widget.htmlbox Widget.htmlbox_config

val explorer_richtext : full ::: {Type}
                        -> tname :: Name -> key ::: Type -> col :: Name
                        -> cols ::: {Type} -> colsDone ::: {Type} -> cstrs ::: {{Unit}}
                        -> impl1 ::: Type -> impl2 ::: Type -> impl3 ::: Type -> old ::: {(Type * {Type} * {Type} * {{Unit}} * Type * Type * Type)}
                        -> [[col] ~ cols] => [[col] ~ colsDone] => [[tname] ~ old]
                        => string
                           -> Explorer.t full ([tname = (key, [col = richtext] ++ cols, colsDone, cstrs, impl1, impl2, impl3)] ++ old)
                           -> Explorer.t full ([tname = (key, [col = richtext] ++ cols, [col = richtext] ++ colsDone, cstrs, Explorer.htmlbox1 impl1, Explorer.htmlbox2 impl2, Explorer.htmlbox3 impl3)] ++ old)

type richtextInBody_cfg
type richtextInBody_st
val richtextInBody : inp ::: Type -> col :: Name -> r ::: {Type} -> [[col] ~ r]
                     => SmartList.t inp ([col = richtext] ++ r) richtextInBody_cfg richtextInBody_st

type richtext_cfg
type richtext_st
val richtext : inp ::: Type -> col :: Name -> r ::: {Type} -> [[col] ~ r]
               => string -> SmartTable.t inp ([col = richtext] ++ r) richtext_cfg richtext_st


(* This operation is to take richtext and format it in a quasi-Markdown style,
say for the plain-text alternative part of an e-mail message. *)
val richTextToPlain : richtext -> string

(* The render class is sort of like `show` but allows for rich formatting, as it
produces not a string but xml. *)
class render
val render : t ::: Type -> render t -> t -> xbody
val mkRender : t ::: Type -> (t -> xbody) -> render t
val render_int : render int
val render_float : render float
val render_money : render money
val render_string : render string
val render_char : render char
val render_bool : render bool
val render_time : render time
val render_unit : render unit
val render_richtext : render richtext
val render_option : t ::: Type -> render t -> render (option t)
val render_list : t ::: Type -> render t -> render (list t)
