val replace : {Id : id,
               Source : source time}
              -> transaction unit

val replaceDate : {Id : id,
                   Source : source time}
                   -> transaction unit

val replaceRange : {Id1 : id,
                    Id2 : id,
                    Source : source (time * time)}
                    -> transaction unit
