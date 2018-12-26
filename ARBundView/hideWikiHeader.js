var styleTag = document.createElement("style");
styleTag.textContent = '.header-container, .after-post.widget-area {display:none;} \
.read-more-container, .after-post.widget-area {display:none;} \
.hlist, .after-post.widget-area {display:none;}';
document.documentElement.appendChild(styleTag);

document.documentElement.style.webkitUserSelect='none';
document.documentElement.style.webkitTouchCallout='none';
var elems = document.getElementsByTagName('a');
for (var i = 0; i < elems.length; i++) {
    elems[i]['href'] = 'javascript:(void)';
}
