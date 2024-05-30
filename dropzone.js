
function setupDropzone(dropzoneId, iframeId, fileTypes, onError, onBegin, onRemove) {
  const dropZoneForm = document.getElementById(dropzoneId);
  dropZoneForm.target = iframeId;
  dropZoneForm.innerHTML = '';
  let myDropzone = new Dropzone(dropZoneForm, {
    addRemoveLinks:true,
    acceptedFiles: fileTypes,
    // This next line along with the following function assures that only one
    // file will ever be available at a time
    maxFiles:1,
    maxfilesexceeded: function(file) {
      this.removeAllFiles();
      this.addFile(file);
    }});

  myDropzone.on("error", (file, message) => {
    execF(execF(onError, {_Filename: file.name, _MimeType: file.type, _Message: message}), null);
    // If the file is no good (and why else would there be an error?), delete it immediately.
    if (!file.accepted) myDropzone.removeFile(file);
  });

  myDropzone.on("addedfile", file => {
    execF(execF(onBegin, {_Filename: file.name, _MimeType: file.type}), null);
  });

  myDropzone.on("removedfile", file => {
    // If the file is not accepted, we're getting called from "error", in which
    // case we shouldn't alert urweb.
    if (file.accepted) execF(onRemove, null);
  });
}


function mkIframe(iframeId) {
  return "<iframe id=\""
    + iframeId
    + "\" name=\""
    + iframeId
    + "\" src=\"about:blank\" style=\"width:0;height:0;border:0px solid #fff;\"></iframe>";
}
