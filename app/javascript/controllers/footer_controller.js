import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = [
    "outro", 
    "showOutro"
  ]

  connect(){

    // 從html讀出文字
    let outro = $("#footer-outro").text()

    // 從html讀出顯示狀態
    let showOutro = $("#footer-outro").is(":visible")

    // 把值塞入表格
    $(this.outroTarget).val(outro)
    this.showOutroTarget.checked = showOutro

  }

  submit(evt){

    // 從表格讀值
    let outro = $(this.outroTarget).val()
    let showOutro = this.showOutroTarget.checked

    // 把文字塞回html
    $("#footer-outro").text(outro)

    // 依true or false控制顯示
    $("#footer-outro").toggle(showOutro)

    // 準備打post更新header
    let articleId = contents.dataset.articleid
    let data = JSON.stringify({
      article: {
        // 抓出header整段html
        footer: footer.outerHTML
      }
    })

    Rails.ajax({
      url: `/article/${articleId}`,
      type: 'PATCH', 
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

    // 側邊欄開關控制
    $("#add").show()
    $("#back").hide()
    $(".edit_content").hide()
    $("#drag-area").show()

  }

}