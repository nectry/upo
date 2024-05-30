
style dropzone

type handle = int
val show_handle = _

sequence handles

sequence clientIds

table scratch : { Handle : handle,
                  Filename : option string,
                  MimeType : string,
                  Content : blob,
                  Created : time }
  PRIMARY KEY Handle

datatype status = Successful of handle | Error of {Filename : string, MimeType : string, Message : string}

(* If the channel is garbage collected, the row will be too *)
table channels : {
  ClientId : int,
  Channel : channel status
} PRIMARY KEY ClientId

(* Clean up files that go unclaimed for 30 minutes. *)
task periodic 900 = fn () =>
    tm <- now;
    dml (DELETE FROM scratch
         WHERE Created < {[addSeconds tm (-(30 * 60))]})

datatype claim_result =
         NotFound
       | Found of { Filename : option string,
                    MimeType : string,
                    Content : blob }

fun claim h =
    ro <- oneOrNoRows1 (SELECT scratch.Filename, scratch.MimeType, scratch.Content
                        FROM scratch
                        WHERE scratch.Handle = {[h]});
    case ro of
        None => return NotFound
      | Some r =>
        dml (DELETE FROM scratch
             WHERE Handle = {[h]});
        return (Found r)

fun peek h =
    ro <- oneOrNoRows1 (SELECT scratch.Filename, scratch.MimeType, scratch.Content
                        FROM scratch
                        WHERE scratch.Handle = {[h]});
    return (case ro of
                None => NotFound
              | Some r => Found r)

fun getNewClientId () =
  clientId <- nextval clientIds;
  ch <- channel;
  dml (INSERT INTO channels (ClientId, Channel)
    VALUES ({[clientId]}, {[ch]}));
  return (ch, clientId)


(* NOTE: This version of dropzone is desisgned to accept a single file upload.
If we want to accept more, there are two tasks.  The easy one is to change the
`setupDropzone` function in dropzone.js to no longer limit us to a single
upload.  The hard one is to somehow keep track of the various upload handles so
that when a file is removed from dropzone, we can call `onDelete` with the
appropriate handle. *)
fun render {
    OnBegin = onBegin,
    OnSuccess = onSuccess,
    OnError = onError,
    OnDelete = onDelete,
    AcceptedMimeTypes = acceptedMimeTypes} =
  iframeId <- fresh;
  dropzoneId <- fresh;
  activeHandle <- source None;
  (ch, clientId) <- rpc (getNewClientId ());
  let
    fun loop () =
      msg <- recv ch;
      (case msg of
          Error e => onError e
        | Successful h => set activeHandle (Some h); onSuccess h);
      loop ()
    val dropZoneRemove : transaction unit =
      h <- get activeHandle;
      case h of
        Some h =>
          onDelete h;
          set activeHandle None
      | None => (* Impossible! *) return ()
    fun uploadAction (r : {File : file}) : transaction page =
      cho <- oneOrNoRowsE1 (
        SELECT (channels.Channel)
        FROM channels
        WHERE channels.ClientId = {[clientId]});
      case cho of
        None => return <xml><body><active code={error <xml>Please refresh your page to continue</xml>}/></body></xml>
      | Some ch =>
          case checkMime (fileMimeType r.File) of
            None =>
              send ch (Error {Filename = Option.get "unknown" (fileName r.File), MimeType = fileMimeType r.File, Message = "Invalid mime type"});
              return <xml></xml>
          | Some _mimeType =>
              h <- nextval handles;
              sqlFilename <- return (case fileName r.File of
                None => (SQL NULL) | Some fname => (SQL {[Some fname]}));
              dml (INSERT INTO scratch (Handle, Filename, MimeType, Content, Created)
                VALUES ({[h]}, {sqlFilename}, {[fileMimeType r.File]}, {[fileData r.File]}, CURRENT_TIMESTAMP));
              send ch (Successful h);
              return <xml></xml>
  in
    spawn (loop ());
    return <xml>
      <form id={dropzoneId} class="dropzone">
        <upload{#File}/>
        <submit action={uploadAction}/>
      </form>
      {DropzoneFfi.mkIframe iframeId}
      <active code={
        DropzoneFfi.setupDropzone dropzoneId iframeId acceptedMimeTypes onError onBegin dropZoneRemove;
        return <xml/>
      }/>
    </xml>
  end
