jQuery.cookie = function (d, e, b) {
    if (arguments.length > 1 && (e === null || typeof e !== "object")) {
        b = jQuery.extend({}, b);
        if (e === null) {
            b.expires = -1
        }
        if (typeof b.expires === "number") {
            var g = b.expires,
                c = b.expires = new Date();
            c.setDate(c.getDate() + g)
        }
        return (document.cookie = [encodeURIComponent(d), "=", b.raw ? String(e) : encodeURIComponent(String(e)), b.expires ? "; expires=" + b.expires.toUTCString() : "", b.path ? "; path=" + b.path : "", b.domain ? "; domain=" + b.domain : "", b.secure ? "; secure" : ""].join(""))
    }
    b = e || {};
    var a, f = b.raw ?
    function (h) {
        return h
    } : decodeURIComponent;
    return (a = new RegExp("(?:^|; )" + encodeURIComponent(d) + "=([^;]*)").exec(document.cookie)) ? f(a[1]) : null
};
$(function () {
    $("body").removeClass("coda-slider-no-js");
    $(".coda-slider").children(".panel").hide().end().prepend('<p class="loading">Loading...<br /><img src="/images/guest/common/ajax-loader.gif" alt="loading..." /></p>')
});
var sliderCount = 1;
$.fn.codaSlider = function (a) {
    a = $.extend({
        autoHeight: true,
        autoHeightEaseDuration: 1000,
        autoHeightEaseFunction: "easeInOutExpo",
        autoSlide: false,
        autoSlideInterval: 7000,
        autoSlideStopWhenClicked: true,
        crossLinking: true,
        dynamicArrows: true,
        dynamicArrowLeftText: "&#171; left",
        dynamicArrowRightText: "right &#187;",
        dynamicTabs: true,
        dynamicTabsAlign: "center",
        dynamicTabsPosition: "top",
        externalTriggerSelector: "a.xtrig",
        firstPanelToLoad: 1,
        panelTitleSelector: "h2.title",
        slideEaseDuration: 1000,
        slideEaseFunction: "easeInOutExpo"
    }, a);
    return this.each(function () {
        var f = $(this);
        if (a.dynamicArrows) {
            f.parent().addClass("arrows");
            f.before('<div class="coda-nav-left" id="coda-nav-left-' + sliderCount + '"><a href="#">' + a.dynamicArrowLeftText + "</a></div>");
            f.after('<div class="coda-nav-right" id="coda-nav-right-' + sliderCount + '"><a href="#">' + a.dynamicArrowRightText + "</a></div>")
        }
        var c = f.find(".panel").width();
        var k = f.find(".panel").size();
        var l = c * k;
        var g = 0;
        $(".panel", f).wrapAll('<div class="panel-container"></div>');
        $(".panel-container", f).css({
            width: l
        });
        if (a.crossLinking && location.hash && parseInt(location.hash.slice(1)) <= k) {
            var d = parseInt(location.hash.slice(1));
            var h = -(c * (d - 1));
            $(".panel-container", f).css({
                marginLeft: h
            })
        } else {
            if (a.firstPanelToLoad != 1 && a.firstPanelToLoad <= k) {
                var d = a.firstPanelToLoad;
                var h = -(c * (d - 1));
                $(".panel-container", f).css({
                    marginLeft: h
                })
            } else {
                var d = 1
            }
        }
        function b(m) {
            m = $.extend({
                offset: 0,
                panel: 1
            }, m);
            $(".panel", f).fadeOut();
            $(".panel:eq(" + parseInt(m.panel - 1) + ")", f).fadeIn()
        }
        $("#coda-nav-left-" + sliderCount + " a").click(function () {
            g++;
            if (d == 1) {
                h = -(c * (k - 1));
                i(k - 1);
                d = k;
                f.siblings(".coda-nav").find("a.current").removeClass("current").parents("ul").find("li:last a").addClass("current")
            } else {
                d -= 1;
                i(d - 1);
                h = -(c * (d - 1));
                f.siblings(".coda-nav").find("a.current").removeClass("current").parent().prev().find("a").addClass("current")
            }
            b({
                offset: h,
                panel: d
            });
            if (a.crossLinking) {
                location.hash = d
            }
            return false
        });
        $("#coda-nav-right-" + sliderCount + " a").click(function () {
            g++;
            if (d == k) {
                h = 0;
                d = 1;
                i(0);
                f.siblings(".coda-nav").find("a.current").removeClass("current").parents("ul").find("a:eq(0)").addClass("current")
            } else {
                h = -(c * d);
                i(d);
                d += 1;
                f.siblings(".coda-nav").find("a.current").removeClass("current").parent().next().find("a").addClass("current")
            }
            b({
                offset: h,
                panel: d
            });
            if (a.crossLinking) {
                location.hash = d
            }
            return false
        });
        if (a.dynamicTabs) {
            var j = '<div class="coda-nav" id="coda-nav-' + sliderCount + '"><ul></ul></div>';
            switch (a.dynamicTabsPosition) {
            case "bottom":
                f.parent().append(j);
                break;
            default:
                f.parent().prepend(j);
                break
            }
            ul = $("#coda-nav-" + sliderCount + " ul");
            $(".panel", f).each(function (m) {
                ul.append('<li class="tab' + (m + 1) + '"><a href="#' + (m + 1) + '">' + $(this).find(a.panelTitleSelector).text() + "</a></li>")
            });
            navContainerWidth = f.width() + f.siblings(".coda-nav-left").width() + f.siblings(".coda-nav-right").width();
            ul.parent().css({
                width: navContainerWidth
            });
            switch (a.dynamicTabsAlign) {
            case "center":
                ul.css({
                    width: ($("li", ul).width() + 2) * k
                });
                break;
            case "right":
                ul.css({
                    "float": "right"
                });
                break
            }
        }
        $("#coda-nav-" + sliderCount + " a").each(function (m) {
            $(this).bind("click", function () {
                g++;
                $(this).addClass("current").parents("ul").find("a").not($(this)).removeClass("current");
                h = -(c * m);
                i(m);
                d = m + 1;
                b({
                    offset: h,
                    panel: d
                });
                if (!a.crossLinking) {
                    return false
                }
            })
        });
        $(a.externalTriggerSelector).each(function () {
            if (sliderCount == parseInt($(this).attr("rel").slice(12))) {
                $(this).bind("click", function () {
                    g++;
                    targetPanel = parseInt($(this).attr("href").slice(1));
                    h = -(c * (targetPanel - 1));
                    i(targetPanel - 1);
                    d = targetPanel;
                    f.siblings(".coda-nav").find("a").removeClass("current").parents("ul").find("li:eq(" + (targetPanel - 1) + ") a").addClass("current");
                    b({
                        offset: h,
                        panel: d
                    });
                    if (!a.crossLinking) {
                        return false
                    }
                })
            }
        });
        if (a.crossLinking && location.hash && parseInt(location.hash.slice(1)) <= k) {
            $("#coda-nav-" + sliderCount + " a:eq(" + (location.hash.slice(1) - 1) + ")").addClass("current")
        } else {
            if (a.firstPanelToLoad != 1 && a.firstPanelToLoad <= k) {
                $("#coda-nav-" + sliderCount + " a:eq(" + (a.firstPanelToLoad - 1) + ")").addClass("current")
            } else {
                $("#coda-nav-" + sliderCount + " a:eq(0)").addClass("current")
            }
        }
        if (a.autoHeight) {
            panelHeight = 442;
            f.css({
                height: panelHeight
            })
        }
        if (a.autoSlide) {
            f.ready(function () {
                setTimeout(e, a.autoSlideInterval)
            })
        }
        function i(m) {
            if (a.autoHeight) {
                panelHeight = $(".panel:eq(" + m + ")", f).height();
                f.animate({
                    height: panelHeight
                }, a.autoHeightEaseDuration, a.autoHeightEaseFunction)
            }
        }
        function e() {
            if (g == 0 || !a.autoSlideStopWhenClicked) {
                if (d == k) {
                    var m = 0;
                    d = 1
                } else {
                    var m = -(c * d);
                    d += 1
                }
                i(d - 1);
                f.siblings(".coda-nav").find("a").removeClass("current").parents("ul").find("li:eq(" + (d - 1) + ") a").addClass("current");
                b({
                    offset: m,
                    panel: d
                });
                setTimeout(e, a.autoSlideInterval)
            }
        }
        $(".panel:first-child", f).show().end().find("p.loading").remove();
        f.removeClass("preload");
        sliderCount++
    })
};
(function (j, o, r) {
    var q = "hashchange",
        l = document,
        n, m = j.event.special,
        k = l.documentMode,
        p = "on" + q in o && (k === r || k > 7);

    function s(a) {
        a = a || location.href;
        return "#" + a.replace(/^[^#]*#?(.*)$/, "$1")
    }
    j.fn[q] = function (a) {
        return a ? this.bind(q, a) : this.trigger(q)
    };
    j.fn[q].delay = 50;
    m[q] = j.extend(m[q], {
        setup: function () {
            if (p) {
                return false
            }
            j(n.start)
        },
        teardown: function () {
            if (p) {
                return false
            }
            j(n.stop)
        }
    });
    n = (function () {
        var d = {},
            e, a = s(),
            c = function (h) {
                return h
            },
            b = c,
            f = c;
        d.start = function () {
            e || g()
        };
        d.stop = function () {
            e && clearTimeout(e);
            e = r
        };

        function g() {
            var h = s(),
                i = f(a);
            if (h !== a) {
                b(a = h, i);
                j(o).trigger(q)
            } else {
                if (i !== a) {
                    location.href = location.href.replace(/#.*/, "") + i
                }
            }
            e = setTimeout(g, j.fn[q].delay)
        }
        j.browser.msie && !p && (function () {
            var i, h;
            d.start = function () {
                if (!i) {
                    h = j.fn[q].src;
                    h = h && h + s();
                    i = j('<iframe tabindex="-1" title="empty"/>').hide().one("load", function () {
                        h || b(s());
                        g()
                    }).attr("src", h || "javascript:0").insertAfter("body")[0].contentWindow;
                    l.onpropertychange = function () {
                        try {
                            if (event.propertyName === "title") {
                                i.document.title = l.title
                            }
                        } catch (t) {}
                    }
                }
            };
            d.stop = c;
            f = function () {
                return s(i.location.href)
            };
            b = function (w, z) {
                var x = i.document,
                    y = j.fn[q].domain;
                if (w !== z) {
                    x.title = l.title;
                    x.open();
                    y && x.write('<script>document.domain="' + y + '"<\/script>');
                    x.close();
                    i.location.hash = w
                }
            }
        })();
        return d
    })()
})(jQuery, this);
$(function (d) {
    var n = d("#marquees");
    if (n.length > 0 && d("#coda-slider-1").length > 0) {
        var g = d("#coda-slider-1");
        var i = g.attr("id").replace("coda-slider-", "");
        var a = d("#coda-history-" + i);
        if (g.length > 0) {
            d("#coda-slider-1").codaSlider({
                firstPanelToLoad: 1,
                dynamicTabs: false,
                dynamicTabsPosition: "bottom",
                dynamicTabsAlign: "center",
                dynamicArrows: false,
                crossLinking: false,
                autoHeight: true,
                slideEaseDuration: 1500,
                autoHeightEaseFunction: "easeInOutExpo",
                slideEaseFunction: "easeInOutExpo"
            });
            n.find(".coda-nav > ul").css("width", d("#marquees .coda-nav > ul").width()).css("float", "none");
            n.find(".coda-nav > ul > li > a > span").click(function (r) {
                var p = d(this).parent().attr("href").replace("#", "");
                var q = "p" + p;
                if (a.is("." + q)) {
                    a.removeClass(q);
                    a.addClass(q)
                } else {
                    a.addClass(q)
                }
                var o = [];
                o = a.attr("class").split(" ");
                if (o.length <= 1) {
                    n.find(".video-container .close").attr("href", "#1")
                } else {
                    n.find(".video-container .close").attr("href", "#" + (o[o.length - 2]).replace("p", ""))
                }
            });
            n.find(".video-container .close").click(function (o) {
                $level = "p" + d(this).attr("href").replace("#", "");
                if (a.is("." + $level)) {
                    a.removeClass($level);
                    a.addClass($level)
                } else {
                    a.addClass($level)
                }
            })
        }
    }
    var l = d(".notifications");
    if (l.length > 0) {
        var m = l.find("li");
        d("> p", m).append('<a href="#close" class="close">close</a>');
        m.each(function (o, p) {
            d(".close", d(p)).live("click", function (q) {
                d.cookie(d(p).attr("id"), "hide", {
                    expires: 365
                });
                d(p).fadeOut().remove();
                q.preventDefault();
                return false
            });
            if (d.cookie(d(p).attr("id")) === "hide") {
                d(p).fadeOut().remove()
            } else {
                d(p).fadeIn()
            }
        })
    }
    d(".help_answer_feedback .radio").live("click", function (q) {
        d(".help_answer_feedback .helpful_inputs").html("Thank you for your feedback!").addClass("check_icon");
        var p = d(q.currentTarget).val();
        var o = {
            faq_id: d(".faq_id").val(),
            question: "helpful",
            answer: p
        };
        d.ajax({
            type: "POST",
            url: "/faq_feedback",
            data: o
        })
    });
    d(".help_feedback").live("submit", function (r) {
        var p = d(r.currentTarget);
        var o = p.attr("action");
        var q = p.serialize();
        d.ajax({
            type: "POST",
            url: o,
            data: q,
            success: function () {
                d(".help_answer_feedback .helpful_feedback_text").html("Thank you for your feedback!").addClass("check_icon")
            }
        });
        r.stopPropagation();
        return false
    });
    d(".help_search").live("submit", function (r) {
        var p = d(r.currentTarget);
        var o = p.attr("action");
        var q = p.serialize();
        d(".step2").fadeOut();
        d(".step3").fadeOut();
        d.ajax({
            type: "GET",
            url: o,
            data: q,
            success: function (s) {
                d(".help_content").html(s.html)
            }
        });
        r.stopPropagation();
        return false
    });
    var b = d(".content-switcher");
    var f = d(".content-switcher-list");
    if (f.length > 0) {
        var h = d("#content-switcher-placeholder");

        function c(o) {
            d.ajax({
                type: "get",
                url: o,
                data: {
                    async: true
                },
                beforeSend: function () {
                    h.html('<img class="loading" src="/images/guest/common/ajax-loader.gif" alt="Loading..." />').fadeIn()
                },
                success: function (p) {
                    h.hide().html(p.html).fadeIn("slow")
                },
                error: function () {
                    h.html('<img class="loading" src="/images/guest/common/ajax-loader.gif" alt="Loading..." />').fadeIn()
                }
            })
        }
        var e = b.find(".content-switcher-list > ul > li > a[rel]");

        function k() {
            d.grep(e, function (p, o) {
                if (d(p).attr("href") === (window.location.hash)) {
                    c(d(p).attr("rel"));
                    e.parent().removeClass("active");
                    d(p).parent().addClass("active")
                }
            })
        }
        k();
        e.each(function (o, p) {
            if (o === 0 && (window.location.hash) === "" && (window.location.search) === "") {
                e.parent().removeClass("active");
                d(this).parent().addClass("active");
                c(d(this).attr("rel"))
            }
            d(p).bind("click", function (q) {
                e.parent().removeClass("active");
                d(this).parent().addClass("active");
                window.location.hash = d(this).attr("href");
                q.preventDefault();
                return false
            })
        });
        d(".tours .next").live("click", function (o) {
            e.parent().removeClass("active");
            d(this).parent().addClass("active");
            window.location.hash = d(this).attr("href");
            o.preventDefault();
            return false
        });
        d(window).hashchange(function () {
            k()
        })
    }
    d("#minimal-home span.picture").click(function () {
        d(this).hide().next().show()
    });
    d(".log_in").click(function () {
        if (d.browser.msie) {
            return true
        }
        d("#login-form").show();
        return false
    });
    d(".login_dialog .x").click(function () {
        d(".login_dialog").hide()
    });
    var j = d("#login-form").submit(function () {
        d.ajax({
            type: "POST",
            url: "/login",
            data: d(this).serialize(),
            success: function (o) {
                if (o.success === true) {
                    location.replace("/logged_in");
                    return
                }
                if (o.error === "No Such Email") {
                    d("#no-such-email").show();
                    j.find(":text").addClass("error").one("change", function () {
                        d(this).removeClass("error");
                        d("#no-such-email").hide()
                    })
                } else {
                    if (o.error === "Incorrect Password") {
                        d("#incorrect-password").show();
                        j.find(":password").addClass("error").one("change", function () {
                            d(this).removeClass("error");
                            d("#incorrect-password").hide()
                        })
                    } else {
                        d("#connection-error").show()
                    }
                }
                d("#authenticating").hide();
                j.show()
            },
            error: function () {
                d("#connection-error").show();
                d("#authenticating").hide();
                j.show()
            }
        });
        j.find("input").blur();
        j.hide();
        d("#authenticating").show();
        return false
    })
});
