const viewingImage = new URLSearchParams(window.location.search).get("Viewing_Image");
const imageToFill = document.getElementById("fillIn")

imageToFill.src = "../images/portfolio".concat('/', viewingImage);
imageToFill.alt = viewingImage;
