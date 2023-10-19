open Bootstrap

functor Make(M : sig
                 con fs :: {Type}
                 val query : sql_query [] [] [] fs
                 val fl : folder fs
                 val show : $(map show fs)
                 val labels : $(map (fn _ => string) fs)
             end) = struct

    open M

    type a = list $fs

    val create = queryL query

    fun onload _ = return ()

    fun render _ a = <xml>
      <table class="bs-table table-striped">
        <thead><tr>
          {@mapX [fn _ => string] [tr]
            (fn [nm ::_] [t ::_] [r ::_] [[nm] ~ r] lab => <xml><th>{[lab]}</th></xml>)
            fl labels}
        </tr></thead>

        <tbody>
          {List.mapX (fn fs => <xml>
            <tr>
              {@mapX2 [show] [ident] [tr]
                (fn [nm ::_] [t ::_] [r ::_] [[nm] ~ r] (_ : show t) (v : t) => <xml><td>{[v]}</td></xml>)
                fl show fs}
            </tr>
          </xml>) a}
        </tbody>
      </table>
    </xml>

    fun notification _ _ = <xml></xml>
    fun buttons _ _ = <xml></xml>

    val ui = {Create = create,
              Onload = onload,
              Render = render,
              Notification = notification,
              Buttons = buttons}

end
