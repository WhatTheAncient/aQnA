document.addEventListener('turbolinks:load', function() {
    const answers = document.querySelector('.answers')
    if (answers)
        answers.addEventListener('click', formInlineLinkHandler)
})

function formInlineLinkHandler(event) {
    const editLinks = this.querySelectorAll('.edit-answer-link')
    for (let i = 0; i < editLinks.length; i++){
        if (event.target === editLinks[i]) {
         event.stopImmediatePropagation()

         const answerId = editLinks[i].dataset.answerId
         formInlineHandler(answerId)
        }
    }
}

function formInlineHandler(answerId) {
    console.log(answerId)
    const link = document.querySelector(`.edit-answer-link[data-answer-id="${answerId}"]`)
    const answer = document.getElementById(`${answerId}`)
    const answerErrors = answer.querySelector('.inline-answer-errors')
    const formInline = document.getElementById(`edit-answer-${answerId}`)

    if (formInline.classList.contains('d-none')) {
        answer.querySelector('.answer-body').classList.add('d-none')
        answerErrors.classList.remove('d-none')
        formInline.classList.remove('d-none')
        link.textContent = 'Cancel'
    } else {
        answer.querySelector('.answer-body').classList.remove('d-none')
        answerErrors.classList.add('d-none')
        formInline.classList.add('d-none')
        link.textContent = 'Edit'
    }
}