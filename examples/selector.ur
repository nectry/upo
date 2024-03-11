val options =
    ("a", "Alpha") ::
    ("b", "Beta") ::
    ("c", "Gamma") :: []

val pg_select2 = <xml>
    <head>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css" rel="stylesheet"/>
    </head>
    <body>
        <active code={
            w <- Select2.createSingle options (Some 1);
            return <xml>
                {Select2.render w}
                <dyn signal={
                    curr <- Select2.selected w;
                    return <xml>
                        <active code={
                            return <xml><p style="color: red">{[curr]}</p></xml>
                        }/>
                       </xml>}/>
                </xml>}/>

    </body>
</xml>

(* val pg_select2_multi : page = <xml>
    <body>
        <active code={
            w <- Select2.createMulti options;
            return <xml>
                {Select2.render w}
                <dyn signal={
                    curr <- Select2.selected w;
                    return <xml>
                        <active code={
                            return <xml><ul>{List.mapX (fn i =>
                            <xml><li style="color: red">{[i]}</li></xml>) curr}</ul></xml>
                        }/>
                       </xml>}/>
                </xml>}/>

    </body>
</xml> *)



fun main () = return pg_select2
