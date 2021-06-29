function signUp() {
  var signUpUrl = "http://localhost:8090/api/auth/register"

  var usernameElement = document.getElementById('username');
  var emailElement = document.getElementById('email');
  var passwordElement = document.getElementById('password');
  var username = usernameElement.value;
  var email = emailElement.value;
  var password = passwordElement.value;

  var xhr = createCORSRequest('POST', signUpUrl);
    xhr.addEventListener('load', function() {
    if (debug == true) {
      console.log('Received:', this.response);
    }
    if (xhr.status == 201) {
      logIn()
    }
    document.getElementById('main-container-overlay').style.display = "none";
  });

  const signUpRequest = {
    username: username,
    email: email,
    password: password,
    confirmPassword: password
  }
  var sendObject = JSON.stringify(signUpRequest);

  if (debug == true) {
    console.log('Send:', sendObject);
  }
  xhr.send(sendObject);
  document.getElementById('main-container-overlay').style.display = "block";
}
