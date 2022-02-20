document.addEventListener('turbolinks:load', function() {
    const answers = document.querySelector('.answers')
    if (answers)
        answers.addEventListener('click', formInlineLinkHandler)

    $('.answers .vote-link').on('ajax:success', function(event) {
        const vote = event.detail[0].vote
        const rating = event.detail[0].rating
        const answer_id = vote.votable_id

        $(`#answer-${answer_id} .vote-link`).each(function(){ $(this).remove() })
        $(`#answer-${answer_id} .vote-rating`).html(`Rating: ${rating}`)

        function sendAjaxDelete(vote) {
            event.preventDefault()
            $.ajax({
                url: `/${vote.votable_type.toLowerCase()}s/${answer_id}/unvote?vote_id=${vote.id}`,
                type: 'DELETE'
            })
        }

        let cancelLink = $(`<a href=''
                                onclick="$.ajax({
                                    url: \`/answers/${answer_id}/unvote?vote_id=${vote.id}\`,
                                    type: 'DELETE',
                                })"> Cancel vote </a>`)

        cancelLink.addClass('btn btn-outline-danger cancel-vote-link')
        $(`#answer-${answer_id} .answer-vote`).append(cancelLink)
    })

    $('.answers .cancel-vote-link').on('ajax:success', function(event) {
        const rating = event.detail[0].rating
        const answer_id = event.detail[0].votable_id

        $(`#answer-${answer_id} .cancel-vote-link`).remove()
        $(`#answer-${answer_id} .vote-rating`).html(`Rating: ${rating}`)

        let upVoteLink = $(`<a href=""
                                onclick="$.ajax({
                                    url: \`/answers/${answer_id}/vote?votable=Answer&vote_state=good\`,
                                    type: 'POST',
                                })"> Good </a>`)

        let downVoteLink = $(`<a href=""
                                onclick="$.ajax({
                                    url: \`/answers/${answer_id}/vote?votable=Answer&vote_state=bad\`,
                                    type: 'POST',
                                })"> Bad </a>`)

        upVoteLink.addClass('btn btn-outline-success vote-link')
        let br = document.createElement('br')
        downVoteLink.addClass('btn btn-outline-danger vote-link')
        $(`#answer-${answer_id} .answer-vote`).append(upVoteLink, br, downVoteLink)
    })

    /*  Ajajson handlers
    $('form.new-answer').on('ajax:success', function(e) {
        const answer = e.detail[0]
        if (answer.body) $('.answers').append(`<p> ${answer.body} </p>`)
    })
        .on('ajax:error', function(e) {
            const errors = e.detail[0]
            $.each(errors, function(index, value) {
                $('.answer-errors').append(`<p> ${value} </p>`)
            })
        })
     */
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
