import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["layout", "title", "desc", "url", "deleteBtn"] 
  // 為了template與saved link兩邊可以共用此方法，所以欄位統一有這麼多
  // 在saved link會有事先存好的資料送到這邊打post
  // 而在template則除了layout外都是空值
  create(evt){
    evt.preventDefault()
    let loaderTemplate = $("#content-insert-loader").get(0).innerHTML
    $(contents).append(loaderTemplate)
    let thisLoader = $(contents).children().get(-1)
    thisLoader.style.height = "150px"
    let data = JSON.stringify({
      layout: this.layoutTarget.value,
      title: this.titleTarget.value,
      desc: this.descTarget.value,
      url: this.urlTarget.value,
    })
    let articleId = contents.dataset.articleid
    Rails.ajax({
      url: `/article/${articleId}/contents`,
      type: 'POST', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      },
      success: resp => {
        $("#form-area").append(resp.form)
        $("#drag_area").append(resp.drag)
        $(thisLoader).replaceWith(resp.show)
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }

  update(evt){
    let form = $(evt.target).parents("form").get(0)
    let id = form.id.split("_")[2]
    let contentTarget = $(`.content[data-id=${id}]`)
    let loaderTemplate = $("#content-insert-loader").get(0).innerHTML
    contentTarget.prepend(loaderTemplate)
    let thisLoader = contentTarget.find(".content-insert-loader").get(0)
    thisLoader.style.position = "absolute"
    thisLoader.style.margin = 0

    $("#add").show()
    $("#back").hide()
    $(".edit_content").hide()
    $("#edit-area").show()
    $("#menu-area").hide()
  }

  delete(evt){
    evt.preventDefault()
    let url = $(this.urlTarget).val()
    let id = this.urlTarget.id
    
    if(confirm("確定刪除此內容？")){
      let contentTarget = $(`.content[data-id=${id}]`)
      let loaderTemplate = $("#content-insert-loader").get(0).innerHTML
      contentTarget.prepend(loaderTemplate)
      let thisLoader = contentTarget.find(".content-insert-loader").get(0)
      thisLoader.style.position = "absolute"
      thisLoader.style.margin = 0
      Rails.ajax({
        url: url,
        type: "DELETE", 
        success: resp => {
          $(`.content[data-id=${id}]`).remove()
          $(`#drag_area div[data-id=${id}]`).remove()
        }, 
        error: err => {
          console.log(err);
        } 
      })
    }
  }
}