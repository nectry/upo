function arrayToUrweb(arr) {
    var ls = null;
    for (var i = arr.length - 1; i >= 0; i--)
        ls = {_1: arr[i].id, _2: ls};
    return ls;
}

function uw_select2_replace(id, onChange) {
    var settings = {width: '100%'};

    var dropdown = $('#' + id).closest('.dropdown-menu, .modal');
    if (dropdown.length > 0)
        settings.dropdownParent = dropdown[0];

    var doChange = function() {
        execF(execF(onChange, arrayToUrweb($('#' + id).select2('data'))), null);
    };
    $('#' + id).select2(settings).change(doChange);
    doChange();
}

function uw_select2_set(id, l) {
  var lst = [];
  for (; l; l = l._2)
      lst.push(l._1);
  $('#' + id).val(lst);
  $('#' + id).trigger(`change`);
}