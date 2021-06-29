function logIn() {
  var logInUrl = "http://localhost:8090/api/auth/login"

  var emailElement = document.getElementById('email');
  var passwordElement = document.getElementById('password');
  var email = emailElement.value;
  var password = passwordElement.value;

  var xhr = createCORSRequest('POST', logInUrl);
  xhr.addEventListener('load', function() {
    var responseObject = JSON.parse(this.response);
    if (debug == true) {
      console.log('Received:', this.response);
    }
    if (responseObject.accessToken) {
      window.sessionStorage.setItem('accessToken', responseObject.accessToken);
      setCookie("accessToken", responseObject.accessToken, 1);
      window.sessionStorage.setItem('refreshToken', responseObject.refreshToken);
      openProtectedURL('console', function() {
        document.getElementById('main-container-overlay').style.display = "none";
      });
    } else {
      console.log("Error: Cannot parse tokens");
    }
  });

  const logInRequest = {
    email: email,
    password: password
  }
  var sendObject = JSON.stringify(logInRequest);

  if (debug == true) {
    console.log('Send:', sendObject);
  }
  xhr.send(sendObject);
  document.getElementById('main-container-overlay').style.display = "block";
}
