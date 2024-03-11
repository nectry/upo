con selector :: (Type -> Type) -> Type -> Type

class singleOrMulti :: (Type -> Type) -> Type
val singleOrMulti_option : singleOrMulti option
val singleOrMulti_list : singleOrMulti list

val createMulti : t ::: Type -> list (t * string * bool) -> transaction (selector list t)
val createSingle : t ::: Type -> list (t * string) -> option int -> transaction (selector option t)

val render : t ::: Type -> k ::: (Type -> Type) -> singleOrMulti k -> selector k t -> xbody

val selected : t ::: Type -> k ::: (Type -> Type) -> monad k -> selector k t -> signal (k t)