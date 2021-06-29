function clickMenu() {
  var menuPopup = document.querySelector('#menu-popup');
  var opened = menuPopup.dataset.opened;
  var menuButtonLink = document.querySelector('#menu-button').firstElementChild;
  var accountMenuButton = document.getElementById("account-button");
  var accountPopup = document.querySelector('#account-popup');
  if (opened == "true") {
    menuPopup.style.display = "none";
    menuButtonLink.style.backgroundImage = "url(../images/hamburger.svg)";
    menuButtonLink.style.backgroundSize = "64px 64px";
    menuButtonLink.style.width = "64px";
    menuButtonLink.style.height = "64px";
    menuPopup.dataset.opened = "false";
    accountMenuButton.style.display = "block";
    enableScroll();
  } else {
    menuPopup.style.display = "block";
    menuButtonLink.style.backgroundImage = "url(../images/close.svg)";
    menuButtonLink.style.backgroundSize = "26px 26px";
    menuButtonLink.style.width = "26px";
    menuButtonLink.style.height = "26px";
    menuPopup.dataset.opened = "true";
    accountMenuButton.style.display = "none";
    accountPopup.style.display = "none";
    disableScroll();
  }
}

function clickAccount() {
  var accountPopup = document.querySelector('#account-popup');
  var haspopup = accountPopup.dataset.haspopup;
  if (haspopup == "true") {
    accountPopup.style.display = "none";
    accountPopup.dataset.haspopup = "false";
  } else {
    accountPopup.style.display = "block";
    accountPopup.dataset.haspopup = "true";
  }
}
