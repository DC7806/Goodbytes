import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["editor"] 

  connect(){
    console.log("hi")
  //   window.sortable = Sortable.create(editor,{
  //     group: "shared",
  //         animation: 250,
  //         ghostClass: "blue-background-class",
  //         onUpdate: function (e) {
  //           console.log(e.item)
  //         },
  //         onAdd: function (e) {
  //           console.log(e.target.querySelector("div.sortable-choosen"));
  //         },
  //   })
  //   console.log(this) 
  //   console.log(e)
  //   this.myCartTarget.classList.add('shake');
  //   this.cartCounterTarget.innerText = e.detail; 
  //   let self = this;

  //   setTimeout(function(){
  //     self.myCartTarget.classList.remove('shake');
  //   }, 500);

  }

}
