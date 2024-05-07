(* selector - describes the state of the select2 component.
 *
 * Parameterized by a type t corresponding to the underlying values, and by a
 *   type -> type k corresponding to how t is wrapped - as a list or as an
 *   an option, corresponding to multi and single selectors.
 *
 * This is necessary to get the functions to be nicely generic.
 *)
type selector k t =
  {Options : xml [Cselect, Body] [] [],
   Values : list t,
   Selected : source (k int),
   Id : id,
   Multi : bool}

(* Typeclass describing how a type is like a list, because it can go to or from
 * a list.  `FromList . ToList` should be the identity.
 *
 * Should be upstreamed
 *)
con listLike k = {
  FromList : t ::: Type -> list t -> k t,
  ToList : t ::: Type -> k t -> list t
}

val listLike_option = {
  FromList = fn [t] lst => case lst of [] => None | x :: _ => Some x,
  ToList = fn [t] o => case o of None => [] | Some x => x :: []
}
val listLike_list = {
  FromList = fn [t] lst => lst,
  ToList = fn [t] lst => lst
}
val listLike_ident = {
  FromList = fn [t] lst => case lst of
      [] => error <xml>listLike is partial for identity!</xml>
    | x :: _ => x,
  ToList = fn [t] x => x :: []
}

(* We shouldn't have to write this - there should be a generic "mappable" or
"functor" with instances for option and list. *)
con mappable k = t ::: Type -> u ::: Type -> (t -> u) -> k t -> k u
fun mappable_option [t] [u] f x = Option.mp f x
fun mappable_list [t] [u] f x = List.mp f x
fun mappable_ident [t] [u] f x = f x

fun createOptions [t ::: Type] (options : list (t * string * bool)) : xml [Cselect, Body] [] [] =
    List.mapXi (fn i (_, x, s) => <xml><coption value={show i} selected={s}>{[x]}</coption></xml>) options

(* Takes a list of options, each one a tuple:
 *   (value : t, display : string, selected : bool)
 *)
fun createMulti [t] options =
    let
      val selection = List.foldr (fn (_, _, s) (i, xs) => if s then (i+1, i :: xs) else (i+1, xs)) (0, []) options
    in
      s <- source selection.2;
      id <- fresh;
      return {
        Options = createOptions options,
        Values = List.mp (fn x => x.1) options,
        Selected = s,
        Id = id,
        Multi = True}
    end

(* Takes a list of options, each one a tuple:
 *   (value : t, display : string)
 * and an option int indexing the list to identify a pre-selected item or
 * lack thereof. If the integer is out of bounds, it is rounded to the
 * beginning or end of the list, so this is safe.
 *)
fun createSingle [t] options selection =
    let
      val selection' = Option.mp (fn x =>  min (max x 0) (List.length options - 1)) selection   (* Protect against index-out-of-bounds. *)
      val options' = List.mapi (fn i (v, x) => (v, x, Some i = selection')) options
    in
      s <- source selection';
      id <- fresh;
      return {
        Options = createOptions options',
        Values = List.mp (fn x => x.1) options,
        Selected = s,
        Id = id,
        Multi = False}
    end

fun createRequiredSingle [t] options selection =
    let
      val selection' = min (max selection 0) (List.length options - 1)
      val options' = List.mapi (fn i (v, x) => (v, x, i = selection')) options
    in
      s <- source selection';
      id <- fresh;
      return {
        Options = createOptions options',
        Values = List.mp (fn x => x.1) options,
        Selected = s,
        Id = id,
        Multi = False}
    end

(* NOTE: We have to prepend a "x" to all the numbers because of some weird
mangling that urweb does.  Similarly, in `render`, we need to take the suffix of
the returned "number" because it has an "x" on the front. *)
fun setSingleSelection' [t] [k] self i =
  Select2Ffi.setValues self.Id (("x" ^ show i) :: [])

fun setMultiSelection' [t] self iLst =
  Select2Ffi.setValues self.Id (List.mp (fn i => "x" ^ show i) iLst)

fun setSingleSelection [t] [k] (_ : eq t) self t =
  case List.findIndex (fn x => x = t) self.Values of
    None => error <xml>Could not set value of select2</xml>
  | Some i => Select2Ffi.setValues self.Id (("x" ^ show i) :: [])

fun setMultiSelection [t] (_ : eq t) self ts =
  let
    fun findIndexOrFail (t : t) =
      case List.findIndex (fn x => x = t) self.Values of
        None => error <xml>Could not set value of select2</xml>
      | Some i => "x" ^ show i
  in
    Select2Ffi.setValues self.Id (List.mp findIndexOrFail ts)
  end

fun render [t] [k] (lstLike : listLike k) (mp : mappable k) self = <xml>
  <active code={return <xml>
                  <span onclick={fn _ => stopPropagation}>
                    <cselect id={self.Id} multiple={self.Multi}>
                      {self.Options}
                    </cselect>
                  </span>
                  <active code={
                    Select2Ffi.replace self.Id
                      (fn x => set self.Selected (mp (fn x => readError (String.suffix x 1)) (lstLike.FromList [string] x)));
                    return <xml></xml>}/>
                </xml>}/>
</xml>

fun lookupValue [t ::: Type] (values : list t) (i : int) : t =
  (* This computation cannot fail since the `i` argument is guaranteed to be in-bounds. *)
  Option.unsafeGet (List.nth values i)

fun selected [t] [k] (mp : mappable k) self =
  s <- signal self.Selected;
  return (mp (lookupValue self.Values) s)