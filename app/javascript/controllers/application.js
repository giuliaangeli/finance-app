import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

function toggleSubcategory() {
    var categoryField = document.getElementById("category_field");
    var subcategoryDiv = document.getElementById("div");

    if (categoryField.value === "") {
        subcategoryDiv.style.display = "none";
    } else {
        subcategoryDiv.style.display = "block";
    }
}
export { application }
