// page navigation 시작
$(document).on('pageinit', '#navigation', function(e, data) {
    $(".menu-navigation").addClass("ui-btn-active");
    startMapNav();

}).on('pageshow', '#navigation', function(e, data) {
    $(".menu-navigation").addClass("ui-btn-active");
    startMapNav();
    $(".nav-map-refresh").click(function() {
        startMapNav();
    });
    $(".menu-favorite").click(function() {
        location.href = "/#search?fav";
    });

    $(".menu-logout").click(function(){
        location.replace("/out");
    });
}).on('pagehide', '#navigation', function(e, data) {
    $(".menu-navigation").removeClass("ui-btn-active");
});

// 구글맵 초기설정
function startMapNav() {
    var windowHeight = $(window).height();
    var headerHeight = 42;
    var mapHeight = windowHeight - headerHeight;
    $('#map_canvas_nav').css("height", mapHeight);
    $('#map_canvas_nav').gmap('refresh');

    var StartLatLng = new google.maps.LatLng(37.746345, 127.02406500000006);
    var dlg = "<table class='nav-tooltip'>";
    dlg += "<tr>";
    dlg += "<td><img src='/images/logo/km.jpg' class='nav-tooltip-logo' alt='kyungmin' /></td>";
    dlg += "<td><ul><li><h1>경민대학교</h1></li>";
    dlg += "<li>경기도 의정부시 가능3동 562-1</li>";
    dlg += "<li><a href='http://www.kyungmin.ac.kr' target='_blank'>www.kyungmin.ac.kr</a></li>";
    dlg += "<li>인터넷정보과</li>";
    dlg += "<li>20151812 양욱모</li>";
    dlg += "</ul></td>";
    dlg += "</tr>";
    dlg += "</table>";
    $('#map_canvas_nav').gmap('addMarker', {
        'position': StartLatLng,
        'bounds': true,
        'icon': markerKMImage
    }).click(function() {
        $('#map_canvas_nav').gmap('openInfoWindow', {
            'content': dlg
        }, this);
    }).triggerEvent('click');
    $('#map_canvas_nav').gmap('option', 'zoom', 14);
    $('#map_canvas_nav').gmap('get', 'map').setOptions({
        'center': StartLatLng
    });
}
