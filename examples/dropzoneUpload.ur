sequence ids

table images : { Id : int, MimeType : string, Content : blob }
  PRIMARY KEY Id

fun choice b =
    widget <- source <xml/>;
    preview <- source <xml/>;
    status <- source <xml/>;

    return <xml>
      <head>
        <link rel="stylesheet" href="https://unpkg.com/dropzone@5/dist/min/dropzone.min.css" type="text/css" />
      </head>
      <body>
      <button
        value="Create new widget"
        onclick={fn _ =>
          au <- Dropzone.render {
            AcceptedMimeTypes = Some "image/*",
            OnBegin = fn f => set status <xml>Uploading {[f.Filename]}</xml>,
            OnError = fn e => set status <xml><strong>Uploading {[e.Filename]} failed:</strong> {[e.Message]}</xml>,
            OnDelete = fn _ => set status <xml/>; set preview <xml/>,
            OnSuccess = fn h =>
              let
                  fun addImage () =
                      r <- Dropzone.claim h;
                      case r of
                          Dropzone.NotFound => return None
                        | Dropzone.Found r =>
                          id <- nextval ids;
                          dml (INSERT INTO images (Id, MimeType, Content)
                              VALUES ({[id]}, {[r.MimeType]}, {[r.Content]}));
                          return (Some id)
              in
                  ido <- rpc (addImage ());
                  case ido of
                      None => alert "Newly uploaded image not found!"
                    | Some id =>
                      let
                          fun image () =
                              r <- oneRow1 (SELECT images.MimeType, images.Content
                                            FROM images
                                            WHERE images.Id = {[id]});
                              returnBlob r.Content (blessMime r.MimeType)
                      in
                          set preview <xml><img src={url (image ())}/></xml>;
                          set status <xml/>
                      end
              end};
          set widget au}/>
      <hr/>
      <dyn signal={signal widget}/>
      <hr/>
      <dyn signal={signal preview}/>
      <p/>
      <dyn signal={signal status}/>
    </body></xml>

fun main () = return <xml><body>
  <a link={choice False}>Normal</a><br/>
  <a link={choice True}>Auto-submit</a>
</body></xml>
