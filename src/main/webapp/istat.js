var timer;
var statLoc;
var data;

var statbg = { top:80, left:20, width:30, height:300}

var jQT = $.jQTouch({
    statusBar: 'black',
    icon:'icon.png',
    startupScreen:'startup.png',
    touchSelector: '#navcontent li'
});


var locations;

function renderLocations(loc) {
    var nc = $('#navcontent').empty();

    for (var i in loc) {
        nc.append($("<li class='arrow' locid='"+loc[i].id+"'>"+ loc[i].display +"</li>"))
    }
}

function update(sel, newText) {
    if (sel.text() != newText) {
        sel.text(newText)
    }
}

function render(statPars)
{
    data = statPars;
    data.top = Math.round(Number(data.csp) - Number(data.off) + data.lim + 1)
    data.bottom = Math.round(Number(data.hsp) - Number(data.off) - data.lim - 1)


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
}

function positionMarker(marker, amount) {
    var markerLeft = statbg.left + statbg.width;
    var markerTop = statbg.top + statbg.height - (11 / 2) - (statbg.height * amount)
    marker.css({left:markerLeft, top:markerTop})
}


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


$(document).ready(function() {
    showBookmarks()
    $('#statback').click(function() {
        if (timer) { clearInterval(timer); timer=null; }
        return true;
    })
    $('#statbg').click(makeWheel)
    .ajaxError(function(e, xhr, settings, exception) {
        //alert('in ajaxerror,url:'+settings.url)
        if (settings.url.indexOf('servlet/stat') == 0) {
            alert('Error reading status')
        }
    })    
})


function refresh() {
    $.get('servlet/stat', {loc:statLoc}, function(data) {
            render(eval(data)[0])
        })
}

function startRefresh() {
    if (timer) { clearInterval(timer); timer=null; }
    timer = setInterval(refresh, 5000)
}

function navStat(location, name) {
    statLoc = location;
    $('#stat h1').text(name)
    $.get('servlet/stat', {loc:location}, function(data) {
        render(eval(data)[0])
        startRefresh();
    })
    jQT.goTo('#stat', 'slide')    
}


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

function stringToJSONString( stringVal ) {
    return "\"" + stringVal.replace('"', '\\"') + "\""
}

