type single
type multi
val createMulti : (* options: *) xml [Cselect, Body] [] [] -> transaction multi
val createSingle (* only select one option *) : xml [Cselect, Body] [] [] -> transaction single

val renderMulti : multi -> xbody
val renderSingle : single -> xbody

val selectedMulti : multi -> signal (list string)
val selectedSingle : single -> signal string
