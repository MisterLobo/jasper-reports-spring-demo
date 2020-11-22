<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Index</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
    body {
        background-color: lightgray;
    }
    </style>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha256-4+XzXVhsDmqanXGHaHvgh1gMQKX40OUvDEBTu8JcmNs=" crossorigin="anonymous"></script>
    <script src="/jrio-client/optimized-scripts/jrio/jrio.js"></script>
</head>
<body>
<div id="toolbar">
    <button id="page_first" disabled>|&lt;</button>
    <button id="page_prev" disabled>&lt;</button>
    <label for="page_current">
        <span>Page</span>
        <input id="page_current" type="text" size="5" disabled>
        <span id="page_total">of <span id="totalPagesNo"></span></span>
    </label>
    <button id="page_next" disabled>&gt;</button>
    <button id="page_last" disabled>&gt;|</button>
</div>
<br/>
<div id="reportContainer"/>
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
            resource: "/samples/reports/TableReport",
            container: "#reportContainer",
            events: {
                changeTotalPages: totalPagesHandler,
                changePagesState: pageStateChangeHandler
            },
            error: failHandler
        });

        var pagesNo = null,
            currentPage = 1;
        function totalPagesHandler(totalPages) {
            if (totalPages == null || totalPages == 0) {
                alert("The report is empty!");
            }

            pagesNo = totalPages;
            updatePaginationButtons();
        }

        function pageStateChangeHandler(pageIndex) {
            currentPage = pageIndex;
            updatePaginationButtons();
        }

        function updatePaginationButtons() {
            if (pagesNo == null) {
                $("#page_next, #page_last").prop("disabled", true);
            }
            else if (pagesNo > 1 && currentPage < pagesNo) {
                $("#page_next, #page_last").prop("disabled", false);
            } else {
                $("#page_next, #page_last").prop("disabled", true);
            }

            if (pagesNo == null || pagesNo == 0) {
                $("#totalPagesNo").text("0");
                $("#page_current").val("");
            } else {
                $("#totalPagesNo").text(pagesNo);
                $("#page_current").val(currentPage);
            }

            if (currentPage == 1) {
                $("#page_first, #page_prev").prop("disabled", true);
            } else {
                $("#page_first, #page_prev").prop("disabled", false);
            }
        }

        $("#page_first").on("click", function (evt) {
            currentPage = 1;
            report.pages(1)
                .run()
                .done(updatePaginationButtons)
                .fail(failHandler);
        });

        $("#page_prev").on("click", function (evt) {
            report.pages(--currentPage)
                .run()
                .done(updatePaginationButtons)
                .fail(failHandler);
        });

        $("#page_next").on("click", function (evt) {
            report.pages(++currentPage)
                .run()
                .done(updatePaginationButtons)
                .fail(failHandler);
        });

        $("#page_last").on("click", function (evt) {
            currentPage = pagesNo;
            report.pages(pagesNo)
                .run()
                .done(updatePaginationButtons)
                .fail(failHandler);
        });

        function failHandler(err) {
          alert(err);
        }
    });
    </script>
</body>
</html>