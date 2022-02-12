document.addEventListener('turbolinks:load', function() {
    const editLink = document.querySelector('.edit-question-link')
    editLink.addEventListener('click', formInlineHandler)
})

function formInlineHandler() {
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