import { Controller } from "stimulus"

export default class extends Controller {
  // 控制選單切換的stimulus controller
  static targets = ["form"]

  toEdit(evt){
    evt.preventDefault()
    $("#edit-area").hide()
    $("#"+this.formTarget.value).show()
    $("#back").show()
    $("#add").hide()
  }

  toDrag(evt){
    $("#add").show()
    $("#back").hide()
    $(".edit_content").hide()
    $("#edit-area").show()
    $("#menu-area").hide()
  }

  toAddContent(evt){
    evt.preventDefault()
    $("#edit-area").hide()
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