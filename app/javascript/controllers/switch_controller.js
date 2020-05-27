import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form"]

  toEdit(evt){
    evt.preventDefault()
    $("#drag-area").hide()
    $("#"+this.formTarget.value).show()
    $("#back").show()
    $("#add").hide()
  }

  toDrag(evt){
    if(evt.target.tagName === "A"){
      evt.preventDefault()
    }
    $("#add").show()
    $("#back").hide()
    $(".edit_content").hide()
    $("#drag-area").show()
    $("#menu-area").hide()
  }

  toAddContent(evt){
    evt.preventDefault()
    $("#drag-area").hide()
    $("#add").hide()
    $("#back").show()
    $("#menu-area").show()
  }
  
  toContentList(evt){
    evt.preventDefault()
    $("#saved_links").hide()
    $("#templates").show()
  }

  toSavedLinks(evt){
    evt.preventDefault()
    $("#saved_links").show()
    $("#templates").hide()
  }


}