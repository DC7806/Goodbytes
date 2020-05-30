// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// import "jquery-ui";
import '@fortawesome/fontawesome-free/css/all.css';
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap";
import "../styles/index.sass";

window.$ = $;

import "controllers";
import "@fortawesome/fontawesome-free/css/all.css";

import "parallax-js";
import Parallax from 'parallax-js'
window.Parallax = Parallax;

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("scripts");
require("popper.js");

// webpack testing all complete!! { Koten }
// console.log(`jQuery testing.. ${$}`)
// console.log(`axios testing... ${axios}`)

// $().ready(function() {
//   console.log($("h1").animate)
// })

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
