document.addEventListener('turbolinks:load', function() {
    const editLink = document.querySelector('.edit-question-link')
    if (editLink) editLink.addEventListener('click', formInlineHandler)

    /*$('.question .vote-link').on('ajax:success', function (event) {
        const vote = event.detail[0].vote
        const rating = event.detail[0].rating
        const questionId = vote.votable_id

        $(`#question-${questionId} .vote-link`).each(function(){ $(this).remove() })
        $(`#question-${questionId} .vote-rating`).html(`Rating: ${rating}`)

        let cancelLink = $(`<a href="/questions"
                                onclick="$.ajax({
                                    url: \`/questions/${questionId}/unvote?vote_id=${vote.id}\`,
                                    type: 'DELETE',
                                })"> Cancel vote </a>`)

        cancelLink.addClass('btn btn-danger cancel-vote-link')
        $(`#question-${questionId} .question-vote`).append(cancelLink)
    })

    $('.question .cancel-vote-link').on('ajax:success', function (event) {
        const rating = event.detail[0].rating
        const questionId = event.detail[0].votable_id

        $(`#question-${questionId} .cancel-vote-link`).remove()
        $(`#question-${questionId} .vote-rating`).html(`Rating: ${rating}`)

        let upVoteLink = $(`<a href="/questions"
                                onclick="$.ajax({
                                    url: \`/questions/${questionId}/vote?votable=Question&vote_state=good\`,
                                    type: 'POST',
                                })"> Good </a>`)

        let downVoteLink = $(`<a href="/questions"
                                onclick="$.ajax({
                                    url: \`/questions/${questionId}/vote?votable=Question&vote_state=bad\`,
                                    type: 'POST',
                                })"> Bad </a>`)

        upVoteLink.addClass('btn btn-outline-success vote-link')
        let br = document.createElement('br')
        downVoteLink.addClass('btn btn-outline-danger vote-link')
        $(`#question-${questionId} .question-vote`).append(upVoteLink, br, downVoteLink)
    })*/
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