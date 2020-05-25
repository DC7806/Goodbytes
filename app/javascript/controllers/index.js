// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
// 其他的JS controller檔案都需要在最前面加上以下這一行：
// import { Controller } from "stimulus"
// 其餘stimulus用法詳見龍哥訂便當專案

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))