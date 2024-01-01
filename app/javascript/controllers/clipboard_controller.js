import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source" ]

  copy(event) {
    this.sourceTarget.select();
    document.execCommand("copy");
    event.preventDefault();
  }
}
