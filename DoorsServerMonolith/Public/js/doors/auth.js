// TODO: ADD JWT VALIDATION

function isAuthorized() {
  var accessToken = window.sessionStorage.getItem('accessToken');
  if (accessToken) {
    return true;
  } else {
    return false;
  }
}

function openProtectedURL(protectedURL, callback) {
  var isAccessTokenValid = false;
  if (isAccessTokenValid) {
    window.open(protectedURL, '_self');
    // callback();
  } else {
    refreshAccessToken( function() {
      window.open(protectedURL, '_self');
      // callback();
    });
  }
}
