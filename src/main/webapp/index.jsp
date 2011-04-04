<%@ page import="java.util.Enumeration" %>
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
<%
    /*
    System.out.print("headers are:");
    Enumeration<String> names = request.getHeaderNames();
    while (names.hasMoreElements()) {
        String nextName = names.nextElement();
        System.out.print(nextName +"="+request.getHeader(nextName)+", ");
    }
    System.out.println("");
    */
%>
<html>
<head>
    <title>iStat</title>
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="minimum-scale=1.0, maximum-scale=1.0, width=device-width" name="viewport">

    <link type="text/css" rel="stylesheet" media="screen" href="jqtouch/jqtouch.css">
    <link type="text/css" rel="stylesheet" media="screen" href="themes/apple/theme.css">
    <style type="text/css">
        #stat {
            background-color:black;
            background-image:none;
            color:white;
        }

        #labels {
            position:absolute;
            left:150px;
            display:none;
        }

        #tempbar {
            position:absolute;
            left:20px;
            top:80px;
            width:30px;
            height:300px;
            background: -webkit-gradient(linear, left top, left bottom, from(#f00), to(#00f));
            background-color:none;
        }
        #current {
            position:absolute;
            top:150px;
            left:110px;
            font-family:arial;
            font-size:80px;
            font-weight:bold;
        }
        .scalelable {
            font-family:arial;
            font-size:16px;
            color:white;
        }

        #toplabel {
            position:absolute;
            top:64px;
            left:65px;
        }
        #bottomlabel {
            position:absolute;
            top:380px;
            left:65px;
        }


        #hmark {
            position:absolute;
            top:100px;
            left:50px;
        }
        #cmark {
            position:absolute;
            top:200px;
            left:50px;
        }

        .deletebutton {
            position:relative;
            overflow: hidden;
            float: right;
            top: -4px;
            right: 0px;
            margin: 0;
            border-width: 0 5px;
            padding: 0 3px;
            width: auto;
            height: 30px;
            line-height: 30px;
            font-family: inherit;
            font-size: 12px;
            font-weight: bold;
            color: #fff;
            text-shadow: rgba(0, 0, 0, 0.5) 0px -1px 0;
            text-overflow: ellipsis;
            text-decoration: none;
            white-space: nowrap;
            background: none;
            -webkit-border-image: url(img/redButton.png) 0 5 0 5;
        }

        #stat .toolbar > h1 {
            left: 60%;
        }

        /* manual back - if I use normal back style, I can't add a tap event handler */
        .manback {
            position: absolute;
            overflow: hidden;
            top: 8px;
            margin: 0;
            width: auto;
            height: 30px;
            line-height: 30px;
            font-family: inherit;
            font-size: 12px;
            font-weight: bold;
            color: #fff;
            text-shadow: rgba(0, 0, 0, 0.5) 0px -1px 0;
            text-overflow: ellipsis;
            text-decoration: none;
            white-space: nowrap;
            background: none;
            left: 6px;
            right: auto;
            padding: 0;
            max-width: 55px;
            border-width: 0 8px 0 14px;
            -webkit-border-image: url(themes/apple/img/backButton.png) 0 8 0 14;
        }


    </style>
    <script type="text/javascript" src="jqtouch/jquery-1.3.2.js"></script>
    <script type="text/javascript" src="jqtouch/jqtouch.js"></script>
    <link rel="stylesheet" href="sw/spinningwheel.css" type="text/css" media="all" />
    <script type="text/javascript" src="sw/spinningwheel.js"></script>
    <script type="text/javascript" src="istat.js"></script>
</head>
<body>
    <!-- Initial Page - Displays bookmarks -->
    <div id="home">
        <div class="toolbar">
            <h1>iStat</h1>
            <a class="button" href="#" onclick="loadTree('')">Add</a>
            
        </div>
        <ul id="navcontent" class="edgetoedge"></ul>
    </div>

    <!-- Add bookmark - tree navigaion -->
    <div id="treetemplate">
        <div class="toolbar">
            <h1>Select a location</h1>
            <a class="button back" href="#">Back</a>
        </div>
        <ul class="edgetoedge"></ul>
    </div>

    <!-- Zone Display Page -->
    <div id="stat">
        <div id="stattool" class="toolbar">
            <h1>iStat</h1>
            <a id="statback" class="manback" href="#">Back</a>
        </div>
        <div id="statbody">
            <div id="tempbar"></div>
            <div id="current"></div>
            <div id="toplabel" class="scalelable stathide">80</div>
            <div id="bottomlabel" class="scalelable stathide">60</div>
            <div id="hmark" class="stathide"><img src="pointleft.png">&nbsp;<span></span></div>
            <div id="cmark" class="stathide"><img src="pointleft.png">&nbsp;<span></span></div>
        </div>

        <!-- labels just for debugging - commenting out now
        <div id="labels">
            <p>HSP=<span id="hsp">???</span> </p>
            <p>CSP=<span id="csp">???</span> </p>
            <p>Loc=<span id="loc">???</span> </p>
            <p>Offset=<span id="off">???</span> </p>
            <p>Limit=<span id="lim">???</span> </p>
            <p>Time=<span id="time">???</span> </p>
            <p id="statloc"></p>
        </div>
        -->
    </div>
</body>
</html>