import '@fortawesome/fontawesome-free/css/all.css';
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap";
import "../styles/index.sass";
import "controllers";

window.$ = $;


import "parallax-js";
import Parallax from 'parallax-js'
window.Parallax = Parallax;

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("scripts");
require("popper.js");

window.fadeOut = function(notify){
  notify.delay(2000).fadeOut("slow")
  setTimeout(()=>{notify.remove()},3000)
}