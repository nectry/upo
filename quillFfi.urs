datatype formatOption
  = Button of string
  | ParamButton of string * string
  | Dropdown of string * list string

type quill

val replace : {Toolbar : list (list formatOption), Id : id, Source : source string} -> transaction quill
val setContent : quill -> string -> transaction unit
