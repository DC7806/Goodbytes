import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["layout", "title", "desc", "url"] 
  // 為了template與saved link兩邊可以共用此方法，所以欄位統一有這麼多
  // 在saved link會有事先存好的資料送到這邊打post
  // 而在template則除了layout外都是空值
  create(evt){
    evt.preventDefault()
    let loaderTemplate = $("#content-insert-loader").get(0).innerHTML
    $(contents).append(loaderTemplate)
    let currentLoader = $(contents).children().get(-1)
    console.log(currentLoader)
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
        $(currentLoader).remove()
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }
}