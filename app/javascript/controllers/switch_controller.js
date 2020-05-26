import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["form"] 
  
  toEdit(evt){
    evt.preventDefault()
    $("#drag-area").hide()
    $("#"+this.formTarget.value).show()
    $("#back").show()
  }

  toDrag(evt){
    if(evt.target.tagName === "A"){
      evt.preventDefault()
    }
    $("#back").hide()
    $(".edit_content").hide()
    $("#drag-area").show()
  }

  toAddContent(evt){
    if(evt.target.tagName === "A"){
      evt.preventDefault()
    }
    console.log(evt.target)
  }
  
  toContentList(evt){
    if(evt.target.tagName === "A"){
      evt.preventDefault()
    }
    console.log(evt.target)
  }


}