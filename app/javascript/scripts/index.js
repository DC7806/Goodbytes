const NAVBAR_OPAQUE_CLASS = "landing_navbar--opaque";

document.addEventListener("DOMContentLoaded", () => {
  const navbar = document.querySelector(".landing_navbar");
  if (!navbar) return;
  window.addEventListener("scroll", () => {
    navbar.classList.toggle(
      NAVBAR_OPAQUE_CLASS,
      window.pageYOffset >= navbar.clientHeight
    );
  });
});
