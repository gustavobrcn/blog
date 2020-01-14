dark_mode_button = document.getElementById("dark-mode-btn")
change_text_color = document.getElementsByClassName("change-textarea-color")
change_button_color = document.getElementsByClassName("change-btn-color")

dark_mode = false
dark_mode_button.addEventListener("click", () => {
    dark_mode = true
    if (dark_mode == true) {
        document.body.style.backgroundColor = "black"
        change_button_color.style.backgroundColor = "black"
        change_text_color.style.backgroundColor = "black"
    }
})
        