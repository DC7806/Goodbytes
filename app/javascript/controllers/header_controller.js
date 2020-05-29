import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = [
    "preheader", 
    "title", 
    "desc", 
    "showPreheader", 
    "showTitle", 
    "showDesc"
  ]

  connect(){

    // 從html讀出文字
    let preheader = $("#header-preheader").text()
    let title = $("#header-title h3").text()
    let desc = $("#header-desc").text()

    // 從html讀出顯示狀態
    let showPreheader = $("#header-preheader").is(":visible")
    let showTitle = $("#header-title h3").is(":visible")
    let showDesc = $("#header-desc").is(":visible")

    // 把值塞入表格
    $(this.preheaderTarget).val(preheader)
    $(this.titleTarget).val(title)
    $(this.descTarget).val(desc)
    this.showPreheaderTarget.checked = showPreheader
    this.showTitleTarget.checked = showTitle
    this.showDescTarget.checked = showDesc

  }

  submit(evt){

    // 從表格讀值
    let preheader = $(this.preheaderTarget).val()
    let title = $(this.titleTarget).val()
    let desc = $(this.descTarget).val()
    let showPreheader = this.showPreheaderTarget.checked
    let showTitle = this.showTitleTarget.checked
    let showDesc = this.showDescTarget.checked

    // 把文字塞回html
    $("#header-preheader").text(preheader)
    $("#header-title h3").text(title)
    $("#header-desc").text(desc)

    // 依true or false控制顯示
    $("#header-preheader").toggle(showPreheader)
    $("#header-title").toggle(showTitle)
    $("#header-desc").toggle(showDesc)

    // 準備打post更新header
    let articleId = contents.dataset.articleid
    let data = JSON.stringify({
      article: {
        // 抓出header整段html
        header: $("#header").get(0).outerHTML
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