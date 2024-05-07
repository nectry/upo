con selector :: (Type -> Type) -> Type -> Type

class listLike :: (Type -> Type) -> Type
val listLike_option : listLike option
val listLike_list : listLike list
val listLike_ident : listLike ident

class mappable :: (Type -> Type) -> Type
val mappable_option : mappable option
val mappable_list : mappable list
val mappable_ident : mappable ident

val createMulti : t ::: Type -> list (t * string * bool) -> transaction (selector list t)
val createSingle : t ::: Type -> list (t * string) -> option int -> transaction (selector option t)
val createRequiredSingle : t ::: Type -> list (t * string) -> int -> transaction (selector ident t)

val render : t ::: Type -> k ::: (Type -> Type) -> listLike k -> mappable k => selector k t -> xbody

val selected : t ::: Type -> k ::: (Type -> Type) -> mappable k -> selector k t -> signal (k t)