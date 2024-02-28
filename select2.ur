type single = {Options : xml [Cselect, Body] [] [],
              Selected : source string}
type multi = {Options : xml [Cselect, Body] [] [],
             Selected : source (list string)}

fun createMulti options =
    s <- source [];
    return {Options = options, Selected = s}

fun createSingle options =
    s <- source "";
    return {Options = options, Selected = s}

fun renderMulti self = <xml>
  <active code={id <- fresh;
                return <xml>
                  <span onclick={fn _ => stopPropagation}>
                    <cselect id={id} multiple={True}>
                      {self.Options}
                    </cselect>
                  </span>
                  <active code={Select2Ffi.replace id (set self.Selected);
                                return <xml></xml>}/>
                </xml>}/>
</xml>

fun renderSingle self = <xml>
  <active code={id <- fresh;
                return <xml>
                  <span onclick={fn _ => stopPropagation}>
                    <cselect id={id} multiple={False}>
                      {self.Options}
                    </cselect>
                  </span>
                  <active code={Select2Ffi.replace id
                    (fn x =>
                        set self.Selected
                        ((fn y => case y of
                            (z :: _) => z
                          | [] => error <xml>Source cannot be empty list</xml>
                        ) x));
                                return <xml></xml>}/>
                </xml>}/>
</xml>

fun selectedMulti self = signal self.Selected

fun selectedSingle self = signal self.Selected
