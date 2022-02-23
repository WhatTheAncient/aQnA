document.addEventListener('turbolinks:load', function() {
    const editLink = document.querySelector('.edit-question-link')
    if (editLink) editLink.addEventListener('click', formInlineHandler)
    const addCommentLink = $('.question .add-comment-link')
    if (addCommentLink) addCommentLink.on('click', commentFormHandler)
})

function formInlineHandler(event) {
    event.preventDefault()
    const link = document.querySelector('.edit-question-link')
    const question = document.querySelector('.question')
    const questionErrors = question.querySelector('.question-errors')
    const formInline = question.querySelector('.inline-form')

    if (formInline.classList.contains('d-none')) {
        question.querySelector('.question-data').classList.add('d-none')
        questionErrors.classList.remove('d-none')
        formInline.classList.remove('d-none')
        link.textContent = 'Cancel'
    } else {
        question.querySelector('.question-data').classList.remove('d-none')
        questionErrors.classList.add('d-none')
        formInline.classList.add('d-none')
        link.textContent = 'Edit question'
    }
}

function commentFormHandler(event) {
    event.preventDefault()
    const questionId = event.target.dataset.questionId
    $(`#question-${questionId} .comment-form`).removeClass('d-none')
    $(`#question-${questionId} .add-comment-link`).addClass('d-none')
}
