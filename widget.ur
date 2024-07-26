
(* A widget of type `t v s c` has a value of type `v`, a client-side state of
type `s`, and server-side configuration state of type `c`.  For example, a
textbox widget would have the type: `t string (source string) ()`.  This
indicates that the value produced by the widget is a `string`, a client can
render/use the textbox precisely with a `source string`, and there's no
server-side configuration needed.  Meanwhile, A dropdown that would provide
values for a foreign keyed table would have type `t (option a) (source string *
source (list a)) (list a)` (where the values of the foreign table are of type
`a`).  This indicates that the resulting value is of type `option a` (either an
`a` value or a lack of selection), the client has everything it needs to render
and use the dropdown assuming it has a `source string` to hold the dropdown's
selection along with a list of possible values (conveniently stored in a source
too, although this isn't strictly nececssary if we never want to reconfigure
it), and the server will produce a `list string` of possible values as a
configuration step. *)
con t (value :: Type) (state :: Type) (config :: Type) =
      { Configure : transaction config,
        Create : config -> transaction state,
        Initialize : config -> value -> transaction state,
        Reset : state -> transaction unit,
        Set : state -> value -> transaction unit,
        Reconfigure : state -> config -> transaction unit,
        AsWidget : state -> option id -> xbody,
        AsWidgetSimple : state -> option id -> xbody,
        (* AsWidgetDisableable : state -> signal bool -> option id -> xbody, *)
          (* Render the widget, but make it editable only when the input signal is True. *)
        Value : state -> signal value,
        AsValue : value -> xbody,
        Optional : bool }

con t' (value :: Type, state :: Type, config :: Type) = t value state config

fun configure [value] [state] [config] (t : t value state config) = t.Configure
fun create [value] [state] [config] (t : t value state config) = t.Create
fun initialize [value] [state] [config] (t : t value state config) = t.Initialize
fun reset [value] [state] [config] (t : t value state config) = t.Reset
fun setValue [value] [state] [config] (t : t value state config) = t.Set
fun reconfigure [value] [state] [config] (t : t value state config) = t.Reconfigure
fun asWidget [value] [state] [config] (t : t value state config) = t.AsWidget
fun asWidget_simple [value] [state] [config] (t : t value state config) = t.AsWidgetSimple
fun value [value] [state] [config] (t : t value state config) = t.Value
fun asValue [value] [state] [config] (t : t value state config) = t.AsValue
fun optional [value] [state] [config] (t : t value state config) = t.Optional

fun make [value] [state] [config] r = r


val textbox = { Configure = return (),
                Create = fn () => source "",
                Initialize = fn () => source,
                Reset = fn s => set s "",
                Set = fn s v => set s v,
                Reconfigure = fn _ () => return (),
                AsWidget = fn s ido =>
                              case ido of
                                  None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                                | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
                AsWidgetSimple = fn s ido =>
                              case ido of
                                  None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                                | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
                Value = signal,
                AsValue = txt,
                Optional = False }

val opt_textbox = { Configure = return (),
                    Create = fn () => source "",
                    Initialize = fn () o => source (Option.get "" o),
                    Reset = fn s => set s "",
                    Set = fn s v => set s (Option.get "" v),
                    Reconfigure = fn _ () => return (),
                    AsWidget = fn s ido =>
                                  case ido of
                                      None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                                    | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
                    AsWidgetSimple = fn s ido =>
                                  case ido of
                                      None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                                    | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
                    Value = fn s =>
                               v <- signal s;
                               return (case v of
                                           "" => None
                                         | _ => Some v),
                    AsValue = fn o => case o of
                                          None => <xml></xml>
                                        | Some s => txt s,
                    Optional = True }

val checkbox = { Configure = return (),
                 Create = fn () => source False,
                 Initialize = fn () => source,
                 Reset = fn s => set s False,
                 Set = fn s v => set s v,
                 Reconfigure = fn _ () => return (),
                 AsWidget = fn s ido =>
                               case ido of
                                   None => <xml><ccheckbox source={s}/></xml>
                                 | Some id => <xml><ccheckbox source={s} id={id}/></xml>,
                 AsWidgetSimple = fn s ido =>
                               case ido of
                                   None => <xml><ccheckbox source={s}/></xml>
                                 | Some id => <xml><ccheckbox source={s} id={id}/></xml>,
                 Value = signal,
                 AsValue = txt,
                 Optional = False }

val opt_checkbox = { Configure = return (),
                     Create = fn () => source False,
                     Initialize = fn () v => source (Option.get False v),
                     Reset = fn s => set s False,
                     Set = fn s v => set s (Option.get False v),
                     Reconfigure = fn _ () => return (),
                     AsWidget = fn s ido =>
                                   case ido of
                                       None => <xml><ccheckbox source={s}/></xml>
                                     | Some id => <xml><ccheckbox source={s} id={id}/></xml>,
                     AsWidgetSimple = fn s ido =>
                                   case ido of
                                       None => <xml><ccheckbox source={s}/></xml>
                                     | Some id => <xml><ccheckbox source={s} id={id}/></xml>,
                     Value = fn st => b <- signal st; return (Some b),
                     AsValue = txt,
                     Optional = True }

val intbox = { Configure = return (),
               Create = fn () => source "",
               Initialize = fn () n => source (show n),
               Reset = fn s => set s "",
               Set = fn s v => set s (show v),
               Reconfigure = fn _ () => return (),
               AsWidget = fn s ido =>
                             case ido of
                                 None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                               | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
               AsWidgetSimple = fn s ido =>
                             case ido of
                                 None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                               | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
               Value = fn s => v <- signal s; return (Option.get 0 (read v)),
               AsValue = txt,
               Optional = False }

val opt_intbox = { Configure = return (),
                   Create = fn () => source "",
                   Initialize = fn () n => source (show n),
                   Reset = fn s => set s "",
                   Set = fn s v => set s (show v),
                   Reconfigure = fn _ () => return (),
                   AsWidget = fn s ido =>
                                 case ido of
                                     None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                                   | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
                   AsWidgetSimple = fn s ido =>
                                 case ido of
                                     None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                                   | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
                   Value = fn s => v <- signal s; return (read v),
                   AsValue = txt,
                   Optional = True }

val timebox = { Configure = return (),
                Create = fn () => DateTimePicker.create None,
                Initialize = fn () n => DateTimePicker.create (Some n),
                Reset = DateTimePicker.reset,
                Set = DateTimePicker.set,
                Reconfigure = fn _ _ => return (),
                AsWidget = fn v _ => DateTimePicker.render v,
                AsWidgetSimple = fn v _ => DateTimePicker.render v,
                Value = DateTimePicker.content,
                AsValue = fn t => if t = minTime then <xml><b>INVALID</b></xml> else txt t,
                Optional = False }

val opt_timebox = { Configure = return (),
                    Create = fn () => DateTimePicker.create None,
                    Initialize = fn () => DateTimePicker.create,
                    Reset = DateTimePicker.reset,
                    Set = fn s tmo => case tmo of None => DateTimePicker.reset s
                                                | Some v => DateTimePicker.set s v,
                    Reconfigure = fn _ _ => return (),
                    AsWidget = fn v _ => DateTimePicker.render v,
                    AsWidgetSimple = fn v _ => DateTimePicker.render v,
                    Value = fn s => v <- DateTimePicker.content s; return (Some v),
                    AsValue = fn t => case t of
                                          None => <xml></xml>
                                        | Some t => if t = minTime then <xml><b>INVALID</b></xml> else txt t,
                    Optional = True }

val datebox = { Configure = return (),
                Create = fn () => DateTimePicker.createDate None,
                Initialize = fn () n => DateTimePicker.createDate (Some n),
                Reset = DateTimePicker.reset,
                Set = DateTimePicker.set,
                Reconfigure = fn _ _ => return (),
                AsWidget = fn v _ => DateTimePicker.render v,
                AsWidgetSimple = fn v _ => DateTimePicker.render v,
                Value = DateTimePicker.content,
                AsValue = fn t => if t = minTime then <xml><b>INVALID</b></xml> else txt t,
                Optional = False }

val opt_datebox = { Configure = return (),
                    Create = fn () => DateTimePicker.createDate None,
                    Initialize = fn () => DateTimePicker.createDate,
                    Reset = DateTimePicker.reset,
                    Set = fn s tmo => case tmo of None => DateTimePicker.reset s
                                                | Some v => DateTimePicker.set s v,
                    Reconfigure = fn _ _ => return (),
                    AsWidget = fn v _ => DateTimePicker.render v,
                    AsWidgetSimple = fn v _ => DateTimePicker.render v,
                    Value = fn s => v <- DateTimePicker.content s; return (Some v),
                    AsValue = fn t => case t of
                                          None => <xml></xml>
                                        | Some t => if t = minTime then <xml><b>INVALID</b></xml> else txt t,
                    Optional = True }

val daterangebox = { Configure = return (),
                Create = fn () => DateTimePicker.createRange None,
                Initialize = fn () n => DateTimePicker.createRange (Some n),
                Reset = DateTimePicker.resetRange,
                Set = DateTimePicker.setRange,
                Reconfigure = fn _ _ => return (),
                AsWidget = fn v _ => DateTimePicker.renderRange v,
                AsWidgetSimple = fn v _ => DateTimePicker.renderRange v,
                Value = DateTimePicker.contentRange,
                AsValue = fn t => if t.1 = minTime then <xml><b>INVALID</b></xml> else <xml>{[t.1]}-{[t.2]}</xml>,
                Optional = False }

val opt_daterangebox = { Configure = return (),
                    Create = fn () => DateTimePicker.createRange None,
                    Initialize = fn () => DateTimePicker.createRange,
                    Reset = DateTimePicker.resetRange,
                    Set = fn s tmo => case tmo of None => DateTimePicker.resetRange s
                                                | Some v => DateTimePicker.setRange s v,
                    Reconfigure = fn _ _ => return (),
                    AsWidget = fn v _ => DateTimePicker.renderRange v,
                    AsWidgetSimple = fn v _ => DateTimePicker.renderRange v,
                    Value = fn s => v <- DateTimePicker.contentRange s; return (Some v),
                    AsValue = fn t => case t of
                                          None => <xml></xml>
                                        | Some t => if t.1 = minTime then <xml><b>INVALID</b></xml> else <xml>{[t.1]}-{[t.2]}</xml>,
                    Optional = True }

val urlbox = { Configure = return (),
               Create = fn () => source "",
               Initialize = fn () => source,
               Reset = fn s => set s "",
               Set = fn s v => set s v,
               Reconfigure = fn _ () => return (),
               AsWidget = fn s ido =>
                             case ido of
                                 None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                               | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
               AsWidgetSimple = fn s ido =>
                             case ido of
                                 None => <xml><ctextbox class={Bootstrap.form_control} source={s}/></xml>
                               | Some id => <xml><ctextbox class={Bootstrap.form_control} source={s} id={id}/></xml>,
               Value = signal,
               AsValue = fn s =>
                           case checkUrl s of
                               None => <xml><b>[BLOCKED URL]</b></xml>
                             | Some url => <xml><a href={url}><tt>{[url]}</tt></a></xml>,
               Optional = False }

fun ed s = QuillRichTextEditor.editor {
  Toolbar = QuillRichTextEditor.defaultToolbar,
  InitialText = s}

val tags = (Html.b, Html.i, Html.a, Html.img, Html.strong, Html.em, Html.p,
  Html.div, Html.br, Html.code, Html.tt, Html.ol, Html.ul, Html.li,
  Html.h1, Html.h2, Html.h3, Html.h4, Html.h5, Html.h6,
  Html.blockquote, Html.s, Html.pre, Html.u, Html.sub, Html.sup, Html.span)

fun html s =
    case Html.format tags s of
        Html.Failure msg => <xml><b>HTML error: {[msg]}</b></xml>
      | Html.Success xm => xm

fun textFromHtml s =
    case Html.formatPlainText tags s of
        Html.Failure msg => "HTML error: " ^ msg
      | Html.Success txt => txt

val htmlbox = {
  Configure = return (),
  Create = fn () => ed "",
  Initialize = fn () => ed,
  Reset = fn me => QuillRichTextEditor.setContent me "",
  Set = fn me v => QuillRichTextEditor.setContent me v,
  Reconfigure = fn _ () => return (),
  AsWidget = fn me _ => QuillRichTextEditor.render me,
  AsWidgetSimple = fn me _ => QuillRichTextEditor.render me,
  Value = QuillRichTextEditor.content,
  AsValue = html,
  Optional = False
}

type choicebox (a :: Type) =
    { Choices : list a,
      Source : source string }

type choicebox_config (a :: Type) = unit

fun choicebox [a ::: Type] (_ : show a) (_ : read a) (choice : a) (choices : list a) =
    { Configure = return (),
      Create = fn () =>
                  s <- source (show choice);
                  return {Choices = choice :: choices, Source = s},
      Initialize = fn () v =>
                      s <- source (show v);
                      return {Choices = choice :: choices, Source = s},
      Reset = fn me => set me.Source (show choice),
      Set = fn me v => set me.Source (show v),
      Reconfigure = fn _ () => return (),
      AsWidget = fn me id =>
                    let
                        val inner = <xml>
                          {List.mapX (fn v => <xml><coption>{[v]}</coption></xml>) me.Choices}
                        </xml>
                    in
                        case id of
                            None => <xml><cselect class={Bootstrap.form_select} source={me.Source}>{inner}</cselect></xml>
                          | Some id => <xml><cselect class={Bootstrap.form_select} id={id} source={me.Source}>{inner}</cselect></xml>
                    end,
      AsWidgetSimple = fn me id =>
                    let
                        val inner = <xml>
                          {List.mapX (fn v => <xml><coption>{[v]}</coption></xml>) me.Choices}
                        </xml>
                    in
                        case id of
                            None => <xml><cselect class={Bootstrap.form_select} source={me.Source}>{inner}</cselect></xml>
                          | Some id => <xml><cselect class={Bootstrap.form_select} id={id} source={me.Source}>{inner}</cselect></xml>
                    end,
      Value = fn me =>
                 s <- signal me.Source;
                 return (case read s of
                             None => choice
                           | Some v => v),
      AsValue = txt,
      Optional = False }

type foreignbox (a :: Type) =
    { Choices : source (list a),
      Source : source string }

type foreignbox_config (a :: Type) = list a

fun foreignbox [a ::: Type] [f ::: Name] (_ : show a) (_ : read a) (q : sql_query [] [] [] [f = a]) =
    { Configure = List.mapQuery q (fn r => r.f),
      Create = fn ls =>
                  ls <- source ls;
                  s <- source "";
                  return {Choices = ls, Source = s},
      Initialize = fn ls v =>
                      ls <- source ls;
                      s <- source (show v);
                      return {Choices = ls, Source = s},
      Reset = fn me => set me.Source "",
      Set = fn me v => set me.Source (show v),
      Reconfigure = fn me ls => set me.Choices ls,
      AsWidget = fn me id =>
                    let
                        fun inner choices = <xml>
                          <coption></coption>
                          {List.mapX (fn v => <xml><coption>{[v]}</coption></xml>) choices}
                        </xml>
                    in
                        <xml>
                          <dyn signal={choices <- signal me.Choices;
                                       return (case id of
                                                   None => <xml><cselect class={Bootstrap.form_select} source={me.Source}>{inner choices}</cselect></xml>
                                                 | Some id => <xml><cselect class={Bootstrap.form_select} id={id} source={me.Source}>{inner choices}</cselect></xml>)}/>
                        </xml>
                    end,
      AsWidgetSimple = fn me id => case id of
                                       None => <xml><ctextbox class={Bootstrap.form_control} source={me.Source}/></xml>
                                     | Some id => <xml><ctextbox class={Bootstrap.form_control} id={id} source={me.Source}/></xml>,
      Value = fn me =>
                 v <- signal me.Source;
                 return (case v of
                             "" => None
                           | _ => read v),
      AsValue = txt,
      Optional = True }

con foreignbox_default = foreignbox
con foreignbox_default_config = foreignbox_config

fun foreignbox_default [a ::: Type] [f ::: Name] (_ : show a) (_ : read a) (q : sql_query [] [] [] [f = a]) (default : a) =
    { Configure = List.mapQuery q (fn r => r.f),
      Create = fn ls =>
                  ls <- source ls;
                  s <- source "";
                  return {Choices = ls, Source = s},
      Initialize = fn ls v =>
                      ls <- source ls;
                      s <- source (show v);
                      return {Choices = ls, Source = s},
      Reset = fn me => set me.Source "",
      Set = fn me v => set me.Source (show v),
      Reconfigure = fn me ls => set me.Choices ls,
      AsWidget = fn me id =>
                    let
                        fun inner choices = <xml>
                          {List.mapX (fn v => <xml><coption>{[v]}</coption></xml>) choices}
                        </xml>
                    in
                        <xml>
                          <dyn signal={choices <- signal me.Choices;
                                       return (case id of
                                                   None => <xml><cselect class={Bootstrap.form_select} source={me.Source}>{inner choices}</cselect></xml>
                                                 | Some id => <xml><cselect class={Bootstrap.form_select} id={id} source={me.Source}>{inner choices}</cselect></xml>)}/>
                        </xml>
                    end,
      AsWidgetSimple = fn me id => case id of
                                       None => <xml><ctextbox class={Bootstrap.form_control} source={me.Source}/></xml>
                                     | Some id => <xml><ctextbox class={Bootstrap.form_control} id={id} source={me.Source}/></xml>,
      Value = fn me =>
                 v <- signal me.Source;
                 return (case v of
                             "" => default
                           | _ => Option.get default (read v)),
      AsValue = txt,
      Optional = False }

functor Fuzzybox(M : sig
                     con f :: Name
                     con fs :: {Type}
                     constraint [f] ~ fs
                     table t : ([f = string] ++ fs)

                     val top_n : int
                 end) = struct
    open M

    datatype stage =
             NotInitialized (* so no point in similarity-sorting *)
           | Initialized of string
           | FetchedSortedList of string

    type state =
         { Stage : source stage,
           Choices : source (list string),
           Source : source string }

    type config = list string

    fun bestMatches v =
        List.mapQuery (SELECT t.{f}
                       FROM t
                       ORDER BY similarity(t.{f}, {[v]}) DESC
                       LIMIT {top_n})
        (fn r => r.T.f)

    fun w () =
        { Configure = List.mapQuery (SELECT t.{f} FROM t ORDER BY t.{f}) (fn r => r.T.f),
          Create = fn ls =>
                      ls <- source ls;
                      s <- source "";
                      st <- source NotInitialized;
                      return {Choices = ls, Source = s, Stage = st},
          Initialize = fn ls v =>
                          ls <- source ls;
                          s <- source v;
                          st <- source (Initialized v);
                          return {Choices = ls, Source = s, Stage = st},
          Reset = fn me => set me.Source "",
          Set = fn me v => set me.Source v; set me.Stage (Initialized v),
          Reconfigure = fn me ls =>
                           set me.Choices ls;
                           st <- get me.Stage;
                           case st of
                               FetchedSortedList v =>
                               set me.Source v;
                               set me.Stage (Initialized v)
                             | _ => return (),
          AsWidget = fn me id =>
                        let
                            fun inner choices = <xml>
                              {List.mapX (fn v => <xml><coption>{[v]}</coption></xml>) choices}
                            </xml>
                        in
                            <xml>
                              <dyn signal={st <- signal me.Stage;
                                           case st of
                                               Initialized v =>
                                               return <xml>
                                                 <active code={spawn (cs <- rpc (bestMatches v);
                                                                      set me.Choices cs;
                                                                      set me.Stage (FetchedSortedList v));
                                                               return <xml></xml>}/>
                                               </xml>
                                             | _ =>
                                               choices <- signal me.Choices;
                                               return (case id of
                                                           None => <xml><cselect class={Bootstrap.form_select} source={me.Source}>{inner choices}</cselect></xml>
                                                         | Some id => <xml><cselect class={Bootstrap.form_select} id={id} source={me.Source}>{inner choices}</cselect></xml>)}/>
                            </xml>
                        end,
          AsWidgetSimple = fn me id => case id of
                                           None => <xml><ctextbox class={Bootstrap.form_control} source={me.Source}/></xml>
                                         | Some id => <xml><ctextbox class={Bootstrap.form_control} id={id} source={me.Source}/></xml>,
          Value = fn me => signal me.Source,
          AsValue = txt,
          Optional = False }
end
