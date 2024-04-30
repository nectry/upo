function uw_dateTimePicker_replace(r) {
    var start = sg(r._Source); // in milliseconds; divide by 1000 to get unix timestamp
    var dtp = $('#' + r._Id);

    const picker = new easepick.create({
        element: dtp,
        date: new Date(start / 1000),
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
               dtp.Value = new Date(v);
           });
}

function uw_dateTimePicker_replaceDate(r) {
    var start = sg(r._Source); // in milliseconds; divide by 1000 to get unix timestamp
    var dtp = $('#' + r._Id);

    const picker = new easepick.create({
        element: dtp,
        date: new Date(start / 1000),
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
               dtp.Value = new Date(v);
           });
}

function uw_dateTimePicker_replaceRange(r) {
    var dates = sg(r._Source);
    var start = dates._1;
    var end = dates._2;
    var dtp1 = $('#' + r._Id1);
    var dtp2 = $('#' + r._Id2);

    const picker = new easepick.create({
        element: dtp1,
        css: [
            'https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css',
            'https://cdn.jsdelivr.net/npm/@easepick/range-plugin@1.2.1/dist/index.css',
        ],
        plugins: ['RangePlugin'],
        RangePlugin: {
            tooltip: true,
            elementEnd: dtp2,
            startDate: new Date(start / 1000),
            endDate: new Date(end / 1000),
        },
        setup(picker) {
            picker.on('select', (e) => {
                const { start, end } = e.detail;
                sv(r._Source, {
                    _1: start.getTime() * 1000,
                    _2: end.getTime() * 1000
                });
            });
        },
    });

    listen(ss(r._Source),
           function(v) {
               dtp.Value = {
                   _1: new Date(v._1),
                   _2: new Date(v._2),
               };
           });
}
