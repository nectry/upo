function uw_dateTimePicker_replace(r) {
    var date = sg(r._Source); // in milliseconds; divide by 1000 to get unix timestamp

    const picker = new easepick.create({
        element: document.getElementById(r._Id),
        date: new Date(date / 1000),
        css: [
            'https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css',
            'https://cdn.jsdelivr.net/npm/@easepick/time-plugin@1.2.1/dist/index.css',
        ],
        plugins: ['TimePlugin'],
        TimePlugin: {
            format: 'HH:mm',
        },
        setup(picker) {
            picker.on('select', (e) => {
                sv(r._Source, e.detail.date.getTime() * 1000);
            });
        },
    });

    listen(ss(r._Source),
           function(v) {
               picker.setDate(new Date(v / 1000));
           });
}

function uw_dateTimePicker_replaceDate(r) {
    var date = sg(r._Source); // in milliseconds; divide by 1000 to get unix timestamp

    const picker = new easepick.create({
        element: document.getElementById(r._Id),
        date: new Date(date / 1000),
        css: [
            'https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css'
        ],
        setup(picker) {
            picker.on('select', (e) => {
                sv(r._Source, e.detail.date.getTime() * 1000);
            });
        },
    });

    listen(ss(r._Source),
           function(v) {
               picker.setDate(new Date(v / 1000));
           });
}

function uw_dateTimePicker_replaceRange(r) {
    var dates = sg(r._Source);

    const picker = new easepick.create({
        element: document.getElementById(r._Id1),
        css: [
            'https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css',
            'https://cdn.jsdelivr.net/npm/@easepick/range-plugin@1.2.1/dist/index.css',
        ],
        plugins: ['RangePlugin'],
        RangePlugin: {
            tooltip: true,
            elementEnd: document.getElementById(r._Id2),
            startDate: new Date(dates._1 / 1000),
            endDate: new Date(dates._2 / 1000),
        },
        setup(picker) {
            picker.on('select', (e) => {
                start = picker.getStartDate();
                end = picker.getEndDate();
                sv(r._Source, {
                    _1: start.date.getTime() * 1000,
                    _2: end.date.getTime() * 1000
                });
            });
        },
    });

    listen(ss(r._Source),
          function(v) {
              picker.setStartDate(new Date(v._1 / 1000));
              picker.setEndDate(new Date(v._2 / 1000));
          });
}
