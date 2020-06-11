import { Controller } from "stimulus"

export default class extends Controller {

  connect(evt) {
    let flash = $(".flash")
    for(let obj of flash.children()){
      fadeOut($(obj))
    }
    flash.on("change", evt => {
      console.log(this)
      console.log(evt.target)
    })
  }

}