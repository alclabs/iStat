/*
 * Copyright (c) 2010 Automated Logic Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

var timer;
var statLoc;
var data;
var adjustable;

var tempbar = { top:80, left:20, width:30, height:300}

var jQT = $.jQTouch({
    statusBar: 'black',
    icon:'icon.png',
    startupScreen:'startup.png',
    touchSelector: '#navcontent li'
});


// jQuery page initialization
$(document).ready(function() {
    showBookmarks()
    $('#statback').tap(function() {
        if (timer) { clearInterval(timer); timer=null; }
        jQT.goBack()
        return true;
    })
    $('#tempbar').click(adjClick)
    .ajaxError(function(e, xhr, settings, exception) {
        //alert('in ajaxerror,url:'+settings.url)
        if (settings.url.indexOf('servlet/stat') == 0) {
            alert('Error reading status')
        }
    })    
})

// -------------------------------------
//       Zone Page

// Click handler for temperature bar
function adjClick() {
    if (adjustable) {
        makeWheel()
    } else {
        alert("Setpoint Not Adjustable");
    }
}

// Triggers refresh of zone values
function refresh() {
    $.get('servlet/stat', {loc:statLoc}, function(data) {
            render(eval(data)[0])
            //console.log("Stat servlet results")
        })
}

// Sets up timer to refresh zone values
function startRefresh() {
    if (timer) { clearInterval(timer); timer=null; }
    timer = setInterval(refresh, 5000)
}



// Updates the zone screen with current status
function render(statPars)
{
    // Note that statPar "numeric" fields are all formatted strings, not numbers
    data = statPars;
    data.top = Math.round(Number(data.csp) - Number(data.off) + Number(data.lim) + 1)
    data.bottom = Math.round(Number(data.hsp) - Number(data.off) - Number(data.lim) - 1)


    adjustable = statPars.adjustable;
    update($('#hsp'),statPars.hsp);
    update($('#csp'),statPars.csp);
    update($('#current'),statPars.current);
    update($('#loc'),statPars.loc);
    update($('#off'),statPars.off);
    update($('#lim'),statPars.lim);
    update($('#time'),statPars.time);

    update($('#toplabel'), data.top)
    update($('#bottomlabel'), data.bottom)

    var range = data.top - data.bottom;
    positionMarker($('#cmark'), (Number(data.csp) - data.bottom) / range)
    positionMarker($('#hmark'), (Number(data.hsp) - data.bottom) / range)
    update($('#cmark > span'), statPars.csp)
    update($('#hmark > span'), statPars.hsp)
    showStat()
}

// Put marker on the tempBar at specified amount (as fraction of bar height) - 1.0 = top, 0.5 = middle
function positionMarker(marker, amount) {
    var markerLeft = tempbar.left + tempbar.width;
    var markerTop = tempbar.top + tempbar.height - (11 / 2) - (tempbar.height * amount)
    marker.css({left:markerLeft, top:markerTop})
}

// Replace text in element with new text
function update(el, newText) {
    if (el.text() != newText) {
        el.text(newText)
    }
}

function hideStat() {
    $('.stathide').css('display','none')
    $('#current').text("??.?")
}

function showStat() {
    $('#toplabel').slideDown('fast');
    $('#cmark').slideDown('fast');
    $('#bottomlabel').slideDown('fast');
    $('#hmark').slideDown('fast');
}

// -------------------------------------
//       Wheel

// Show pop-up wheel picker
function makeWheel() {
    var numbers = new Object();

    var i=0;
    for (var next=data.lim; next >= (-1 * data.lim); next -= 0.5) {
        var delta = next - data.off;
        var str = "";
        if (delta > 0) {
            str += "+";
        }

        str += delta;
        if (Math.round(delta) == delta)
        str += '.0';

        str+= "  ";
        if (delta > 0) {
            str += "deg Warmer"
        } else if (delta < 0) {
            str += "deg Cooler"
        } else {
            str += "deg - Don't change"
        }

        numbers[i++] = str;
    }

    function findWheelIndexForOffset(off) {
        return (data.lim - off) * 2
    }

    function findOffsetForWheelIndex(index) {
        return (data.lim - (index / 2.0))
    }

    SpinningWheel.addSlot(numbers, 'shrink', findWheelIndexForOffset(data.off));

    //SpinningWheel.setCancelAction(cancel);
    SpinningWheel.setDoneAction(function() {
        var results = SpinningWheel.getSelectedValues();

        $.get('servlet/adjust', {loc:statLoc, value:findOffsetForWheelIndex(results.keys[0])}, 
                function() { setTimeout(refresh, 1000)} )

    });

    SpinningWheel.open($('#statbody')[0]);
}


// -------------------------------------
//       Bookmarks

// Display page w/ list of favorites. This function retrieves data and sets up handlers
function showBookmarks(afterFunc) {
    $.post('servlet/bookmark', { 'bookmarks':getBookmarks() }, function(data) {
        renderLocations(eval(data));
        $('#navcontent li').click(function(evt) {
            var id = evt.target.getAttribute('locid');
            var name = evt.target.innerText
            var deleteButton = $('.deletebutton');
            if (deleteButton.size() > 0) {
                deleteButton.remove();
            }
            else {
                navStat(id, name);
            }
        })
        .swipe( function(evt, info) {
            if (info.direction == 'right') {
                showDelete(evt.target)
            }
        })
        .dblclick( function(evt) {
            showDelete(evt.target)
        })
        if (afterFunc) { afterFunc() }
    })
}

// Render returned bookmark locations into HTML
function renderLocations(loc) {
    var nc = $('#navcontent').empty();

    for (var i in loc) {
        nc.append($("<li class='arrow' locid='"+loc[i].id+"'>"+ loc[i].display +"</li>"))
    }
}

var treeCount = 0;
function loadTree(treeLocation) {
    $.get('servlet/tree',{LOC:treeLocation}, function(data) {
        var name = renderTreeElements(eval(data));
        $('#'+name+' li').click(function(evt) {
            var targetId = evt.target.getAttribute('locid');
            if (evt.target.getAttribute('class') == 'arrow') {
                loadTree(targetId);
            }
            else {
                addBookmark(targetId);
                showBookmarks(function() { jQT.goBack('#home') });
            }
        })
        // first load slides up, others slide from the side
        jQT.goTo("#"+name, (treeLocation.length==0)?"slideup":"slide")
    })

}

function renderTreeElements(elements) {
    var newName = 'tree'+treeCount++
    var newContent = $('#treetemplate').clone()
    newContent.attr('id',newName)
    newContent.addClass('tree')
    newContent.insertAfter('#treetemplate')

    var newList = newContent.find('ul')

    for (var i in elements) {
        var nextEl = elements[i]
        var elString = "<li "
        if (nextEl.area) {
            elString += "class='arrow' "
        }
        elString += "locid='" + nextEl.id+"'>" + nextEl.display +"</li>"
        newList.append($(elString))
    }
    return newName
}

function showDelete(el) {
    var line = $(el).append('<a class="deletebutton"> Delete </a>')
    var a = line.find('a')
    a[0].focus()
    a.bind('tap', function(evt) {
        removeBookmark(line.attr('locid'))
        line.remove()
        evt.stopImmediatePropagation()
        evt.preventDefault()
    })
    .bind('blur', function(evt) {
        a.remove()
    })
}

function getBookmarks() {
    var bms = localStorage.bookmarks
    if (bms) {
        return eval(bms)
    }
    else {
        return [];
    }
}

function addBookmark(bookmark) {
    currentBookmarks = getBookmarks();
    currentBookmarks.push(bookmark)
    saveBookmarks(currentBookmarks)
}

function saveBookmarks(bookmarks) {
    var stringForm = "["
    for (i in bookmarks) {
        stringForm += stringToJSONString(bookmarks[i]) + ", "
    }
    stringForm += "]";
    localStorage.bookmarks = stringForm
}

function removeBookmark(bookmark) {
    var currentBookmarks = getBookmarks()
    for (var i in currentBookmarks) {
        if (currentBookmarks[i] == bookmark) {
            currentBookmarks.splice(i, 1);
        }
    }
    saveBookmarks(currentBookmarks)
}

// Navigate to a zone
function navStat(location, name) {
    hideStat()
    statLoc = location;
    $('#stat h1').text(name)
    $.get('servlet/stat', {loc:location}, function(data) {
        render(eval(data)[0])
        startRefresh();
    })
    jQT.goTo('#stat', 'slide')
}


function stringToJSONString( stringVal ) {
    return "\"" + stringVal.replace('"', '\\"') + "\""
}

