<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="/jrio-client/optimized-scripts/jrio/jrio.js"></script>
</head>
<body>
<label for="exportOptions">Select export format</label>
<select id="exportOptions" disabled>
    <option value="pdf">PDF</option>
    <option value="xlsx">XLSX</option>
    <option value="docx">DOCX</option>
    <option value="pptx">PPTX</option>
    <option value="csv">CSV</option>
    <option value="xls">XLS</option>
    <option value="rtf">RTF</option>
    <option value="odt">ODT</option>
    <option value="ods">ODS</option>
    <option value="html">HTML</option>
    <option value="xml">XML</option>
    <option value="data_csv">CSV Metadata</option>
    <option value="data_json">JSON Metadata</option>
    <option value="data_xls">XLS Metadata</option>
</select>
<button id="export" disabled>Export</button>
<br/><br/>
<div id="reportContainer">
</div>
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
	var report = jrioClient.report({
    	resource: "/samples/reports/FirstJasper",
        container: "#reportContainer",
        events: {
            reportCompleted: function(status) {
                if ("ready" === status) {
                	enableControl("exportOptions");
                  enableControl("export");
                }
            }
        },
        error: failHandler,
    });

    document.getElementById("export").addEventListener("click", function() {
    	var optsElem = document.getElementById("exportOptions"),
      	exportFormat = optsElem.options[optsElem.selectedIndex].value;

      disableControl("export");
      report.export({
        outputFormat: exportFormat
      }).done(function (link) {
        enableControl("export");
        window.open(link.href, "_blank");
      }).fail(failHandler);

    });

    function enableControl(controlId) {
    	document.getElementById(controlId).disabled = false;
    }

    function disableControl(controlId) {
    	document.getElementById(controlId).disabled = true;
    }

    function failHandler(err) { alert(err); }
});

</script>
</body>
</html>