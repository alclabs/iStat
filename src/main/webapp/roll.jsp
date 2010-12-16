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

<%--
  Created by IntelliJ IDEA.
  User: sappling
  Date: Apr 6, 2010
  Time: 4:33:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="minimum-scale=1.0, width=device-width, maximum-scale=1.0" name="viewport">
    <link rel="stylesheet" href="sw/spinningwheel.css" type="text/css" media="all" />
    <script src="sw/spinningwheel.js" type="application/x-javascript"></script>

    <style type="text/css">
        .white { color: white; }
        #temp {
            color: white;
            font-family:Times New Roman;
            font-size:80px;
            font-weight:100;
            -webkit-text-size-adjust: none;
            position:absolute;
            top:100px;
            left:50px;
        }

        #cool {
            color: white;
            font-family:Times New Roman;
            font-size:40px;
            position:absolute;
            top:10px;
            left:230px;
            z-index:100;
        }
        #templabel {
            color: white;
            font-family:Verdana;
            font-size:15px;
            position:absolute;
            top:190px;
            left:50px;
        }
        #coollabel {
            color: white;
            font-family:Verdana;
            font-size:15px;
            position:absolute;
            top:55px;
            left:230px;
        }

        body {
            overflow-x: hidden;
            -webkit-user-select: none;
            -webkit-text-size-adjust: none;
            font-family: Helvetica;
            -webkit-perspective: 800;
            -webkit-transform-style: preserve-3d;
        }

        #other {
            -webkit-backface-visibility: hidden;
            -webkit-box-sizing: border-box;
            -webkit-transform: translate3d(0,0,0) rotate(0) scale(1);
            position:absolute;
            left: 0;
            top:20px;
            width: 100%;
            min-height: 420px !important;
        }


    </style>

    <script type="application/x-javascript">
       function wheel() {
    var numbers = new Object();
    for (var i=60; i<80; i++) {
        var str = i+'.0';
        numbers[str] = str;
        str = i+'.5';
        numbers[str] = str;
    }
	SpinningWheel.addSlot(numbers, 'shrink', document.getElementById('cool').innerHTML);

	SpinningWheel.setCancelAction(cancel);
	SpinningWheel.setDoneAction(done);

	SpinningWheel.open(document.getElementById('other'));
}

function done() {
	var results = SpinningWheel.getSelectedValues();
	document.getElementById('cool').innerHTML=results.values[0];
}

function cancel() {
}
    </script>

</head>
<body style="background-color:black">
<div class="white">Header</div>
<div id="temp">68.7</div>
<div id="templabel">current</div>

<div id="cool" onclick="wheel()">70.0</div>
<div id="coollabel">setpoint</div>
<div id="other">
</div>
</body>
</html>