import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["form", "objectId","switcher", "url", "toId"] 
  
  toEdit(evt){
    evt.preventDefault()
    $("#edit-area").hide()
    $("#"+this.formTarget.value).show()
    $("#back").show()
    $("#add").hide()
  }

  toDrag(evt){
    evt.preventDefault()
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
    $("#menu-area > .d-flex > .templates").addClass('card-menu-active')
    $("#menu-area > .d-flex > .saved_links").removeClass('card-menu-active')
  }

  toSavedLinks(evt){
    evt.preventDefault()
    $("#saved_links").show()
    $("#templates").hide()
    $("#menu-area > .d-flex > .saved_links").addClass('card-menu-active')
    $("#menu-area > .d-flex > .templates").removeClass('card-menu-active')
  }
  
  sideListToggle(evt){
    evt.preventDefault()
    let targetObject = $("#" + this.objectIdTarget.value)
    targetObject.fadeToggle("fast")
    this.switcherTarget.focus()
    $(this.switcherTarget).on("focusout", function(){
      // 為了可以點擊menu外就隱藏menu，於是加了onFocusOut
      // 同時也是為了解決同時開兩個menu的問題
      targetObject.fadeOut()
    })
  }
  
  movePlace(evt){
    evt.stopPropagation()
    evt.preventDefault()
    let data = JSON.stringify({id: this.toIdTarget.value})
    Rails.ajax({
      url: this.urlTarget.value,
      type: 'POST', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      },
      success: resp => {
        // 其實就是redirect_to，在javascript裡的寫法是這樣
        window.location.replace("/channel");
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }

  toEditSubject(evt){
    evt.preventDefault()
    $(".top-bar a.title").toggle()
    $(".top-bar a.edit").toggle()
    $(".top-bar a.submit").toggle()
    $(".top-bar a.cancel").toggle()
    $("#subject-editor").toggle()
    if($("#subject-editor").is(":visible")){
      $("#subject-editor").focus()
    }
  }

  groupListToggle(evt){
    evt.preventDefault()
    $(".group-list").fadeToggle("fast")
    evt.target.focus()
    $(evt.target).on("focusout", (evt)=>{
      $(".group-list").fadeOut()
    })
  }

  linkGroup(evt){
    evt.preventDefault()
    let target = evt.target
    let current = $(".current-group").get(0)
    let targetName = target.innerText
    let targetId = target.dataset.id
    let currentGroup = $(`#link-group-${current.dataset.id}`) 
    let targetGroup = $(`#link-group-${targetId}`) 
    currentGroup.toggle()
    targetGroup.toggle()
    target.innerText = current.innerText
    target.dataset.id = current.dataset.id
    current.innerText = targetName
    current.dataset.id = targetId
  }

}