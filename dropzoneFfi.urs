val setupDropzone :
  id ->
  id ->
  option string ->
  ({Filename : string, MimeType : string, Message : string} -> transaction unit) ->
  ({Filename : string, MimeType : string} -> transaction unit) ->
  transaction unit ->
  transaction unit

val mkIframe : id -> xbody
