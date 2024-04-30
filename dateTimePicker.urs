type t
type tRange
val create : option time -> transaction t
val createDate : option time -> transaction t
val createRange : option (time * time) -> transaction tRange
val render : t -> xbody
val content : t -> signal time
val reset : t -> transaction unit
val set : t -> time -> transaction unit
val resetRange : tRange -> transaction unit
val setRange : tRange -> (time * time) -> transaction unit
