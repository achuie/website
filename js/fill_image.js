const viewingImage = new URLSearchParams(window.location.search).get("Viewing_Image");
const imageToFill = document.getElementById("fillIn")

imageToFill.src = "../images/portfolio".concat('/', viewingImage);
imageToFill.alt = viewingImage;
// Replace underscores and remove file extension
document.title = viewingImage.replace(/_/g, " ").replace(/\.[^/.]+$/, "") + " – AH";
