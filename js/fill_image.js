var GET = {};
var query = window.location.search.substring(1).split("&");
for (var i = 0, max = query.length; i < max; i++) {
  // check for trailing & with no param
  if (query[i] === "")
    continue;

  var param = query[i].split("=");
  GET[decodeURIComponent(param[0])] = decodeURIComponent(param[1] || "");
}
var imageToFill = document.getElementById("fillIn")
imageToFill.src = "../images/portfolio".concat('/', GET.Viewing_Image);
imageToFill.alt = GET.Viewing_Image;
