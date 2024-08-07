open Bootstrap

con r = _
val fl = _

val css =
    {Bootstrap = bless "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css",
     FontAwesome = bless "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/fontawesome.min.css",
     FontAwesomeSolid = bless "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/solid.min.css",
     FontAwesomeRegular = bless "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/regular.min.css",
     Select2 = bless "https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css",
     Quill = bless "https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css",
     Fullcalendar = bless "https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/4.2.0/core/main.min.css",
     FullcalendarDaygrid = bless "https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/4.2.0/daygrid/main.min.css",
     FullcalendarTimegrid = bless "https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/4.2.0/timegrid/main.min.css",
     EasePickDatePicker = bless "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css",
     EasePickDateRangePicker = bless "https://cdn.jsdelivr.net/npm/@easepick/range-plugin@1.2.1/dist/index.css",
     Dropzone = bless "https://unpkg.com/dropzone@5/dist/min/dropzone.min.css",
     Upo = bless "/style.css"}

val navclasses = CLASS "navbar navbar-expand-md navbar-dark fixed-top bg-dark"
val icon = None
fun wrap b = b
val titleInNavbar = True
