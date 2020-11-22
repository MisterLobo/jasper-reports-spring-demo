<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Index</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha256-4+XzXVhsDmqanXGHaHvgh1gMQKX40OUvDEBTu8JcmNs=" crossorigin="anonymous"></script>
    <script src="/jrio-client/optimized-scripts/jrio/jrio.js"></script>
</head>
<body>
    <div id="reportContainer"></div>
    <div style="font-size: 11pt">Scroll down to view additional reports.</div>
    <br/>
    <div id="reportContainer1"></div>
    <br/>
    <div id="reportContainer2"></div>
    <script>
    jrio.config({
        server : "/jrio",
        scripts : "/jrio-client/optimized-scripts",
        theme: {
            href: "/jrio-client/themes/default"
        },
        locale: "en_US"
    });
    jrio(function(jrioClient) {
        jrioClient.report({
            resource: "/samples/reports/Demo/Cherry_1",
            container: "#reportContainer",
            error: function(err) { alert(err); },
        });

        jrioClient.report({
            resource: "/samples/reports/TableReport",
            container: "#reportContainer1",
            error: function(err) { alert(err); },
        });

        jrioClient.report({
            resource: "/samples/reports/highcharts/HighchartsChart",
            container: "#reportContainer2",
            error: function(err) { alert(err); },
        });
    });
    </script>
</body>
</html>