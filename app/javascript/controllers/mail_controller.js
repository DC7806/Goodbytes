import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  deliver(evt){
    evt.preventDefault()
    if (!confirm("確定要寄出嗎？")) return 
    let mailTarget
    if(evt.target.dataset.value === "all"){
      mailTarget = $("input[name=article]").get().filter((x)=>{return x.dataset.delivered==="false"}).map((x)=>{return x.value})
    }else{
      mailTarget = [evt.target.dataset.value]
    }
    let data = JSON.stringify({articles: mailTarget})
    Rails.ajax({
      url: "/channel/deliver",
      type: 'POST', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      },
      success: resp => {
        window.location.replace("/channel");
        alert("已成功寄出！")
      }, 
      error: err => {
        window.location.replace("/channel");
        alert("寄送失敗！請聯絡頻道管理者！")
      } 
    })

  }
}


// $("input[name=article]").get().filter((x)=>{return x.dataset.delivered==="false"})