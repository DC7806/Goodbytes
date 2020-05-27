import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["form"] 
  
  edit(evt){
    evt.preventDefault()
    $("#drag-area").hide()
    $("#"+this.formTarget.value).show()
    $("#back").show()
  }

  drag(evt){
    console.log(evt.target.tagName)
    if(evt.target.tagName === "A"){
      evt.preventDefault()
    }
    $("#back").hide()
    $(".edit_content").hide()
    $("#drag-area").show()
  }


}