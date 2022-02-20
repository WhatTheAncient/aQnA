document.addEventListener('turbolinks:load', function() {
    const editLink = document.querySelector('.edit-question-link')
    if (editLink) editLink.addEventListener('click', formInlineHandler)

    $('.question .vote-link').on('ajax:success', function (event) {
        const vote = event.detail[0].vote
        const rating = event.detail[0].rating

        $('.question .vote-link').each(function(){ $(this).remove() })
        $('.question .vote-rating').html(`Rating: ${rating}`)
    })
    $('.question .cancel-vote-link').on('ajax:success', function (event) {
        const rating = event.detail[0].rating

        $('.question .cancel-vote-link').remove()
        $('.question .vote-rating').html(`Rating: ${rating}`)
    })
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