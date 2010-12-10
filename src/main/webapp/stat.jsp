<%--
  Created by IntelliJ IDEA.
  User: sappling
  Date: Mar 29, 2010
  Time: 2:26:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>iStat</title>
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="minimum-scale=1.0, maximum-scale=1.0, width=device-width" name="viewport">
    <link type="text/css" rel="stylesheet" media="screen" href="jqtouch/jqtouch.css">
    <link type="text/css" rel="stylesheet" media="screen" href="themes/apple/theme.css">
    <style type="text/css">
        #navcontent {
            width:100%;
            height:100%;
            background:black;
            color:white;
        }

        #stat {
            background-color:black;
            background-image:none;
            color:white;
        }

    </style>
    <script type="text/javascript" src="jqtouch/jquery.1.3.2.min.js"></script>
    <script type="text/javascript" src="jqtouch/jqtouch.js"></script>
    <script type="text/javascript">
        var jQT = $.jQTouch({
         statusBar: 'black'
        });

        function testit() {
            svg.getElementById('temp_marker').setAttribute('transform','translate(-31,50)')
        }
    </script>
</head>
<body>

    <div id="home">
        <div class="toolbar">
            <h1>iStat</h1>
            <a class="back" href="#">Back</a>
        </div>
        <!--
        <ul id="navcontent" class="edgetoedge">
            <li class="arrow"><a href="#stat">Stat</a></li>
        </ul>
        -->
    </div>
    <div id="stat" class="current">
        <div class="toolbar">
            <h1>iStat</h1>
            <a class="back" href="#">Back</a>
        </div>
        <div id="inside">

            <embed id="svg" src="stat.svg" width="200" height="300"></embed>
            <br/>
            <button onclick="testit()">Test</button>
        </div>
    </div>
</body>
</html>