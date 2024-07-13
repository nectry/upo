
datatype formatOption = datatype QuillFfi.formatOption

type toolbar = list (list formatOption)

datatype heading = H1 | H2 | H3 | H4 | H5 | H6 | HNone
fun headingToString h = case h of
  H1 => "1" | H2 => "2" | H3 => "3" | H4 => "4" | H5 => "5" | H6 => "6" | HNone => ""

datatype listType = Ordered | Bullet | Check
fun listTypeToString l = case l of
  Ordered => 'ordered' | Bullet => 'bullet' | Check => 'check'

datatype alignment = Left | Center | Right | Justify
fun alignmentToString a = case a of
  Left => "" | Center => "center" | Right => "right" | Justify => "justify"

datatype fontsize = Small | Normal | Large | Huge
fun fontsizeToString s = case s of
  Small => "small" | Normal => "" | Large => "large" | Huge => "huge"

fun headingButton (h : heading) : formatOption = ParamButton ("header", headingToString h)
fun headingDropdown (hs : list heading) : formatOption = Dropdown ("header", List.mp headingToString hs)
fun fontSizeDropdown (fs : list fontsize) : formatOption = Dropdown ("size", List.mp fontsizeToString fs)
fun alignmentDropdown (as : list alignment) : formatOption = Dropdown ("align", List.mp alignmentToString as)
fun alignmentButton (a : alignment) : formatOption = ParamButton ("align", alignmentToString a)
val orderedListButton = ParamButton ("list", "ordered")
val bulletListButton = ParamButton ("list", "bullet")
val checkmarkListButton = ParamButton ("list", "check")
val subscriptButton = ParamButton ("script", "sub")
val superscriptButton = ParamButton ("script", "super")
val boldButton = Button "bold"
val italicButton = Button "italic"
val underlineButton = Button "underline"
val strikeButton = Button "strike"
val blockquoteButton = Button "blockquote"
val codeblockButton = Button "code-block"
val linkButton = Button "link"
val imageButton = Button "image"
val colorDropdown = Dropdown ("color", [])
val backgroundColorDropdown = Dropdown ("background", [])
val fontDropdown = Dropdown ("font", [])
val removeFormattingButton = Button "clean"

val defaultToolbar : toolbar =
  (boldButton :: italicButton :: underlineButton :: strikeButton :: []) ::
  (blockquoteButton :: codeblockButton :: []) ::
  ((headingDropdown (H1 :: H2 :: H3 :: H4 :: H5 :: H6 :: HNone :: [])) :: []) ::
  (subscriptButton :: superscriptButton :: []) ::
  (linkButton :: imageButton :: []) ::
  (orderedListButton :: bulletListButton :: []) ::
  (removeFormattingButton :: []) ::
  []

type editor = {
  Quill : source (option QuillFfi.quill),
  Source : source string,
  Render : xbody}

fun editor r =
    id <- fresh;
    s <- source r.InitialText;
    quill <- source None;
    return {
      Quill = quill,
      Source = s,
      Render = <xml>
        <div id={id}/>
        <active code={
          quillV <- QuillFfi.replace (r -- #InitialText ++ {Id = id, Source = s});
          set quill (Some quillV);
          return <xml/>}/>
      </xml>}

fun render ed = ed.Render

fun content ed = signal ed.Source

fun setContent ed s =
  set ed.Source s;
  (* ed.Quill is None if we're setting before the editor has run, in which case
  all we needed to do is set the source *)
  quillO <- get ed.Quill;
  case quillO of
    None => return ()
  | Some quill => QuillFfi.setContent quill s
