function refreshAccessToken(callback) {
  var refreshAccessTokenUrl = "http://localhost:8090/api/auth/accessToken"

  var xhr = createCORSRequest('POST', refreshAccessTokenUrl);
  xhr.addEventListener('load', function() {
    var responseObject = JSON.parse(this.response);
    if (debug == true) {
      console.log('Received:', this.response);
    }
    if (responseObject.accessToken) {
      window.sessionStorage.setItem('accessToken', responseObject.accessToken);
      setCookie("accessToken", responseObject.accessToken, 1);
      window.sessionStorage.setItem('refreshToken', responseObject.refreshToken);
      callback();
    } else {
      console.log("Error: Cannot parse tokens");
    }
  });

  const refreshAccessTokenOutput = {
    refreshToken: window.sessionStorage.getItem('refreshToken')
  }
  var sendObject = JSON.stringify(refreshAccessTokenOutput);

  if (debug == true) {
    console.log('Send:', sendObject);
  }
  xhr.send(sendObject);
}
