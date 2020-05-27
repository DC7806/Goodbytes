import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["layout", "title", "desc", "url"] 
  create(evt){
    evt.preventDefault()
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
        
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }
}