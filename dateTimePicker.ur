open DateTimePickerFfi

type t = {Id : id,
          Source : source time,
          Show : xbody}
type tRange = {Id1 : id,
               Id2 : id,
               Source : source (time * time),
               Show : xbody}

fun create tmo =
    tm <- (case tmo of
               None => now
             | Some tm => return tm);
    id <- fresh;
    s <- source tm;
    return {Id = id,
            Source = s,
            Show = <xml>
              <ctextbox id={id}/>
              <active code={DateTimePickerFfi.replace {Id = id, Source = s};
                            return <xml></xml>}/>
                                               </xml>}

fun createDate tmo =
    tm <- (case tmo of
               None => now
             | Some tm => return tm);
    id <- fresh;
    s <- source tm;
    return {Id = id,
            Source = s,
            Show = <xml>
              <ctextbox id={id}/>
              <active code={DateTimePickerFfi.replaceDate {Id = id, Source = s};
                            return <xml></xml>}/>
                                               </xml>}

fun createRange tmo =
    tms <- (case tmo of
               None => (tmStart <- now;
                        return (tmStart, addSeconds tmStart (24 * 60 * 60)))
             | Some tms => return tms);
    id1 <- fresh;
    id2 <- fresh;
    s <- source tms;
    return {Id1 = id1,
            Id2 = id2,
            Source = s,
            Show = <xml>
              <ctextbox id={id1}/>
              <ctextbox id={id2}/>
              <active code={DateTimePickerFfi.replaceRange {Id1 = id1, Id2 = id2, Source = s};
                            return <xml></xml>}/>
            </xml>}

fun render ed = ed.Show

fun content ed = signal ed.Source

fun reset ed = tm <- now; set ed.Source tm
fun set ed tm = Basis.set ed.Source tm

fun resetRange ed =
    tmStart <- now;
    tmEnd <- return (addSeconds tmStart (24 * 60 * 60));
    set ed.Source (tmStart, tmEnd)
fun setRange ed tms = Basis.set ed.Source (tms.1, tms.2)
