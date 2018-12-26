var styleTag = document.createElement("style");
styleTag.textContent = '.header-container, .after-post.widget-area {display:none;}';
document.documentElement.appendChild(styleTag);
document.getElementById("page-actions").style.display = "none"
document.body.style.color = "red";
