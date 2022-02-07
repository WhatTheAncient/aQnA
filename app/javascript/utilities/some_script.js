document.addEventListener('turbolinks:load', function() {
    const answers = document.querySelectorAll('.answers')
    if (answers)
        answers.forEach((element) => element.addEventListener('click', formInlineLinkHandler))
})

function formInlineLinkHandler(event) {
    const editLink = this.querySelector('.edit-answer-link')
    console.log(event.target === editLink)
    if (event.target === editLink) {
        event.stopImmediatePropagation();

        const answerId = editLink.dataset.answerId
        formInlineHandler(answerId)
    }
}

function formInlineHandler(answerId) {
    console.log(answerId)
    const link = document.querySelector(`.edit-answer-link[data-answer-id="${answerId}"]`)
    const answer = document.getElementById(`${answerId}`)
    const formInline = document.getElementById(`edit-answer-${answerId}`)

    if (formInline.classList.contains('d-none')) {
        answer.querySelector('.answer-body').classList.add('d-none')
        formInline.classList.remove('d-none')
        link.textContent = 'Cancel'
    } else {
        answer.querySelector('.answer-body').classList.remove('d-none')
        formInline.classList.add('d-none')
        link.textContent = 'Edit'
    }
}