<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd"><%
response.setHeader("Expires", "Wed, 01 Jan 2003 12:00:00 GMT");
response.setHeader("Cache-Control", "no-cache"); %>
<html>
<head>
    <title>test</title>
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="minimum-scale=1.0, maximum-scale=1.0, width=device-width" name="viewport">

    <link type="text/css" rel="stylesheet" media="screen" href="jqtouch/jqtouch.css">
    <link type="text/css" rel="stylesheet" media="screen" href="themes/apple/theme.css">
    <script type="text/javascript" src="jqtouch/jquery.1.3.2.min.js"></script>
    <script type="text/javascript" src="jqtouch/jqtouch.js"></script>
    <script type="text/javascript">

        var jQT = $.jQTouch();
        $(document).ready(function() {
            $('#testa').tap(function() {
                console.log('a handler')
            })


            $('#testdiv').tap(function() {
                console.log('div handler')
            })
        })

    </script>
</head>
<body>
    <div id="home">
        <a id="testa">A Link</a>
        <br><br><br>
        <div id="testdiv">A Div</div>
    </div>
</body>
</html>