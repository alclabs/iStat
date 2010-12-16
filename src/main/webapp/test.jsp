<%--
  ~ Copyright (c) 2010 Automated Logic Corporation
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining a copy
  ~ of this software and associated documentation files (the "Software"), to deal
  ~ in the Software without restriction, including without limitation the rights
  ~ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  ~ copies of the Software, and to permit persons to whom the Software is
  ~ furnished to do so, subject to the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be included in
  ~ all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  ~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  ~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  ~ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  ~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  ~ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  ~ THE SOFTWARE.
  --%>

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