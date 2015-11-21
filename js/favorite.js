function delFavorite(idx, a) {
    if (confirm("삭제하시겠습니까?")) {
        loadingDelIconStart();
        $.ajax({
            url: "/ac/favorite/del.jsp",
            data: "idx=" + idx,
            type: "POST",
            success: function(data) {
                $(a).parent().remove();
                loadingIconEnd();
            },
            error: function(data) {
                alert(data);
                loadingIconEnd();
            }
        });
    } else {
        return false;
    }

}

function loadingDelIconStart() {
    $.mobile.loading("show", {
        text: "삭제 중...",
        textVisible: true,
        theme: "b",
        html: ""
    });
}

function loadingIconEnd() {
    $.mobile.loading("hide");
}

function scrollFavTop() {
    $('body, html').animate({
        scrollTop: 0
    }, 500);
}

function scrollFavBottom() {
    $("html, body").animate({
        scrollTop: $(document).height()
    }, 1000);
}
