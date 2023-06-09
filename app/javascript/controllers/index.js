// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

window.$ = window.jQuery = require('jquery');
require("jquery-mask-plugin");

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.maskFields();
  }
  
  maskFields() {
    $('[data-masks-target="phone"]').mask('(00) 00000-0009');
    $('[data-masks-target="cpf"]').mask('000.000.000-00');;
  }
}