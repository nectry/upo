

con formatOption :: Type

(* See https://quilljs.com/docs/modules/toolbar for more info *)
type toolbar = list (list formatOption)

datatype heading = H1 | H2 | H3 | H4 | H5 | H6 | HNone
datatype listType = Ordered | Bullet | Check
datatype alignment = Left | Center | Right | Justify
datatype fontsize = Small | Normal | Large | Huge

val headingDropdown : list heading -> formatOption
val headingButton : heading -> formatOption
val alignmentDropdown : list alignment -> formatOption
val alignmentButton : alignment -> formatOption
val fontSizeDropdown : list fontsize -> formatOption
val orderedListButton : formatOption
val bulletListButton : formatOption
val checkmarkListButton : formatOption
val subscriptButton : formatOption
val superscriptButton : formatOption
val boldButton : formatOption
val italicButton : formatOption
val underlineButton : formatOption
val strikeButton : formatOption
val blockquoteButton : formatOption
val codeblockButton : formatOption
val linkButton : formatOption
val imageButton : formatOption
val colorDropdown : formatOption
val backgroundColorDropdown : formatOption
val fontDropdown : formatOption
val removeFormattingButton : formatOption

val defaultToolbar : toolbar

type editor

val editor : {Toolbar : toolbar, InitialText : string} -> transaction editor
val render : editor -> xbody
val content : editor -> signal string
val setContent : editor -> string -> transaction unit
