<%@ page import="java.util.Enumeration" %>
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

        #statbg {
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


    </style>
    <script type="text/javascript" src="jqtouch/jquery-1.3.2.js"></script>
    <script type="text/javascript" src="jqtouch/jqtouch.js"></script>
    <link rel="stylesheet" href="sw/spinningwheel.css" type="text/css" media="all" />
    <script type="text/javascript" src="sw/spinningwheel.js"></script>
    <script type="text/javascript" src="istat.js"></script>
</head>
<body>

    <div id="home">
        <div class="toolbar">
            <h1>iStat</h1>
            <a class="button" href="#" onclick="loadTree('')">Add</a>
            
        </div>
        <ul id="navcontent" class="edgetoedge"></ul>
    </div>
    <div id="treetemplate">
        <div class="toolbar">
            <h1>Select a location</h1>
            <a class="button back" href="#">Back</a>
        </div>
        <ul class="edgetoedge"></ul>
    </div>
    <div id="stat">
        <div id="stattool" class="toolbar">
            <h1>iStat</h1>
            <a id="statback" class="back" href="#">Back</a>
        </div>
        <div id="statbody">
            <div id="statbg"></div>
            <div id="current"></div>
            <div id="toplabel" class="scalelable">80</div>
            <div id="bottomlabel" class="scalelable">60</div>
            <div id="hmark"><img src="pointleft.png">&nbsp;<span></span></div>
            <div id="cmark"><img src="pointleft.png">&nbsp;<span></span></div>
        </div>
        <div id="labels">
            <p>HSP=<span id="hsp">???</span> </p>
            <p>CSP=<span id="csp">???</span> </p>
            <p>Loc=<span id="loc">???</span> </p>
            <p>Offset=<span id="off">???</span> </p>
            <p>Limit=<span id="lim">???</span> </p>
            <p>Time=<span id="time">???</span> </p>
            <p id="statloc"></p>
        </div>
    </div>
</body>
</html>