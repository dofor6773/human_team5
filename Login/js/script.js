// const maxAttempts = 3;
// let failedAttempts = localStorage.getItem("failedAttempts")
//   ? parseInt(localStorage.getItem("failedAttempts"))
//   : 0;

// //로그인 실패 횟수
// window.addEventListener("DOMContentLoaded", () => {
//   if (failedAttempts >= maxAttempts) {
//     lockAccount();
//   }
// });
// 비밀번호 표시 버튼
document.getElementById("togglePassword").addEventListener("click", function () {
  const passwordField = document.getElementById("password");
  const toggleIcon = document.getElementById("toggle-icon");

  if (passwordField.type === "password") {
    passwordField.type = "text";
    toggleIcon.src = "eye-icon.png";
    toggleIcon.alt = "비밀번호 표시";
  } else {
    passwordField.type = "password";
    toggleIcon.src = "eye-slash-icon.png";
    toggleIcon.alt = "비밀번호 숨기기";
  }
});
//아이디 저장
document.addEventListener("DOMContentLoaded", function () {
  const usernameField = document.getElementById("username");
  const rememberMe = document.getElementById("rememberMe");

  const savedUsername = localStorage.getItem("savedUsername");
  if (savedUsername) {
    usernameField.value = savedUsername;
    rememberMe.checked = true;
  }

  document.getElementById("loginForm").addEventListener("submit", function () {
    if (rememberMe.checked) {
      localStorage.setItem("savedUsername", usernameField.value);
    } else {
      localStorage.removeItem("savedUsername");
    }
  });
});
// // 로그인 폼 유효성 검사 및 실패 시도 제한
// document.getElementById("loginForm").addEventListener("submit", function (event) {
//   event.preventDefault();

//   const username = document.getElementById("username").value;
//   const password = document.getElementById("password").value;

//   const usernamePattern = /^[a-zA-Z0-9]{4,}$/; // 아이디: 최소 4자, 알파벳/숫자만
//   const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/; // 비밀번호 유효성 검사

//   if (!usernamePattern.test(username)) {
//     alert("아이디는 4자 이상, 알파벳과 숫자만 입력하세요.");
//     return;
//   }

//   if (!passwordPattern.test(password)) {
//     alert("비밀번호는 8자 이상, 대문자, 소문자, 숫자, 특수문자를 포함해야 합니다.");
//     return;
//   }

//   // 예시: 유효한 아이디와 비밀번호
//   const validUsername = "admin";
//   const validPassword = "Password123!";

//   if (username === validUsername && password === validPassword) {
//     alert("로그인 성공!");
//     localStorage.setItem("failedAttempts", 0)
//     window.location.href = "/main";
//   } else {
//     failedAttempts++;
//     localStorage.setItem("failedAttempts", failedAttempts);

//     if (failedAttempts >= maxAttempts) {
//       lockAccount();
//     } else {
//       alert(`로그인 실패! 남은 시도 횟수: ${maxAttempts - failedAttempts}`);
//     }
//   }
// });

// function lockAccount() {
//   document.getElementById("loginButton").disabled = true;
//   document.getElementById("lockMessage").style.display = "block";
//   alert("로그인 시도가 너무 많습니다. 관리자에게 문의하세요");
// }