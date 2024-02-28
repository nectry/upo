val options = <xml>
    <coption value="a">Alpha</coption>
    <coption value="b" selected={True}>Beta</coption>
    <coption value="c">Gamma</coption>
</xml>

val pg_select2 = <xml>
    <body>
        <active code={
            w <- Select2.createSingle options;
            return <xml>
                {Select2.renderSingle w}
                <dyn signal={
                    curr <- Select2.selectedSingle w;
                    return <xml>
                        <active code={
                            return <xml><p style="color: red">{[curr]}</p></xml>
                        }/>
                       </xml>}/>
                </xml>}/>

    </body>
</xml>

val pg_select2_multi : page = <xml>
    <body>
        <active code={
            w <- Select2.createMulti options;
            return <xml>
                {Select2.renderMulti w}
                <dyn signal={
                    curr <- Select2.selectedMulti w;
                    return <xml>
                        <active code={
                            return <xml><ul>{List.mapX (fn i =>
                            <xml><li style="color: red">{[i]}</li></xml>) curr}</ul></xml>
                        }/>
                       </xml>}/>
                </xml>}/>

    </body>
</xml>



fun main () = return pg_select2
