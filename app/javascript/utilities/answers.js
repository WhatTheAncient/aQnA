document.addEventListener('turbolinks:load', function() {
    const answers = document.querySelector('.answers')
    if (answers)
        answers.addEventListener('click', formInlineLinkHandler)
    const addCommentLinks = answers.querySelectorAll('.add-comment-link')
    if (addCommentLinks.length)
        addCommentLinks.forEach((link) => {link.addEventListener('click', commentFormHandler)})
})

function formInlineLinkHandler(event) {
    const editLinks = this.querySelectorAll('.edit-answer-link')
    for (let i = 0; i < editLinks.length; i++){
        if (event.target === editLinks[i]) {
            event.preventDefault()
            event.stopImmediatePropagation()

            const answerId = editLinks[i].dataset.answerId
            formInlineHandler(answerId)
        }
    }
}

function formInlineHandler(answerId) {
    const link = document.querySelector(`.edit-answer-link[data-answer-id="${answerId}"]`)
    const answer = document.getElementById(`answer-${answerId}`)
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

function commentFormHandler(event) {
    event.preventDefault()
    const answerId = event.target.dataset.answerId

    $(`#answer-${answerId} .comment-form`).removeClass('d-none')
    $(`#answer-${answerId} .add-comment-link`).addClass('d-none')
}
