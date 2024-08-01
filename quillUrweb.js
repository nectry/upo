
function urwebToJsList(lst) {
  var out = [];
  for (; lst != null; lst = lst._2)
    out.push(lst._1);
  return out;
}

function quillConvertToolbar(toolbars) {
  var toolbarsOut = [];
  for (; toolbars != null; toolbars = toolbars._2) {
    var toolbarSection = toolbars._1;
    var toolbarSectionOut = [];
    for (; toolbarSection != null; toolbarSection = toolbarSection._2) {
      feature = toolbarSection._1;
      if (feature.n == "Button") {
        toolbarSectionOut.push(feature.v);
      } else if (feature.n == "ParamButton") {
        toolbarSectionOut.push({[feature.v._1]: feature.v._2})
      } else if (feature.n == "Dropdown") {
        toolbarSectionOut.push({[feature.v._1]: urwebToJsList(feature.v._2)});
      } else
        throw ("Invalid quill toolbar feature: " + feature);
    }
    toolbarsOut.push(toolbarSectionOut);
  }
  return toolbarsOut;
}


function uw_quill_setContent(quill, s) {
  quill.setText('', 'silent');
  quill.clipboard.dangerouslyPasteHTML(s, 'silent');
}

function uw_quill_replace(r) {
  const quillToolbar = quillConvertToolbar(r._Toolbar);
  const quill = new Quill('#' + r._Id, {
    modules: {
      toolbar: quillToolbar
    },
    bounds: '#' + r._Id,
    theme: 'snow'
  });
  quill.on('text-change', (delta, oldDelta, source) => {
    sv(r._Source, quill.getSemanticHTML());
  });
  uw_quill_setContent(quill, sg(r._Source))
  return quill;
}
