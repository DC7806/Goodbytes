import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["layout", "title", "desc", "url"] 
  // 為了template與saved link兩邊可以共用此方法，所以欄位統一有這麼多
  // 在saved link會有事先存好的資料送到這邊打post
  // 而在template則除了layout外都是空值
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
        $('.flash').append(
          `<div class="alert alert-success">
            <a class="close" data-dismiss="warning">&#215;</a>
              <ul>
                <li>
                  已新增樣板
                </li>
              </ul>
          </div>`)
        let notify = $($(".flash").find(".alert").get(-1))
        notify.delay(2000).fadeOut("slow")
        setTimeout(()=>{that.remove()},3000)
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }


}