(** A simple widget for uploading files to the server without reloading the current page *)

(* Unique ID for a file that has been uploaded *)
type handle

(* HACK: Exposing this is not ideal, but it's pretty convenient. It's critical that `read` is not exposed. *)
val show_handle : show handle

datatype claim_result
    (* That file was either claimed by someone else or was uploaded too long ago and never claimed. *)
  = NotFound
  | Found of {
      Filename : option string,
      MimeType : string,
      Content : blob}

(* In server-side code, claim ownership of a [handle]'s contents, deleting the persistent record of the file data. *)
val claim : handle -> transaction claim_result

(* Like [claim], but keeps the file in temporary storage.  Beware that files older than 30 minutes may be removed automatically! *)
val peek : handle -> transaction claim_result

(* Produce HTML for a file upload control *)
val render : {
  (* Run this when an upload begins. *)
  OnBegin : {Filename : string, MimeType : string} -> transaction unit,
  (* Run this after a successful upload. *)
  OnSuccess : handle -> transaction unit,
  (* Run this when upload fails (probably because of an unsupported MIME type). *)
  OnError : {Filename : string, MimeType : string, Message : string} -> transaction unit,
  (* Run this if the user wants to abandon the upload). *)
  OnDelete : handle -> transaction unit,
  (* This is a comma separated list of mime types or file extensions.  Eg.:
  "image/*,application/pdf,.psd".  If `None`, then any file is accepted. *)
  AcceptedMimeTypes : option string}
  -> transaction xbody
