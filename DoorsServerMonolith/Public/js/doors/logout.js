function logOut() {
  window.localStorage.clear();
  window.sessionStorage.clear();
  setCookie("accessToken", "", 0);
  window.open('/', '_self');
}
