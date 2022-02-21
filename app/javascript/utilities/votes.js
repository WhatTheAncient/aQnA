$(document).on('turbolinks:load', function() {
    questionVotesHandler()
    answerVotesHandler()
})

function questionVotesHandler(event) {
    const resourceSelector = '.question'
    voteHandler(resourceSelector)
    unvoteHandler(resourceSelector)
}

function answerVotesHandler(event) {
    const resourceSelector = '.answer'
    voteHandler(resourceSelector)
    unvoteHandler(resourceSelector)
}

function voteHandler(resourceSelector) {
    $(`${resourceSelector} .vote-link`).on('ajax:success', function(event) {
        const vote = event.detail[0].vote
        const rating = event.detail[0].rating
        const votableId = vote.votable_id
        const votableName = vote.votable_type

        $(`#${votableName.toLowerCase()}-${votableId} .vote-link`).each(function(){ $(this).remove() })
        $(`#${votableName.toLowerCase()}-${votableId} .vote-rating`).html(`Rating: ${rating}`)

        let cancelVoteButton = $('<button/>', { text: 'Cancel vote' })
        cancelVoteButton.addClass('btn btn-danger cancel-vote-link')

        const voteField = $(`#${votableName.toLowerCase()}-${votableId} .${votableName.toLowerCase()}-vote`)

        voteField.append(cancelVoteButton)

        voteField.find('button:contains("Cancel vote")').on("click", function() {
            $.ajax({
                url: `/${votableName.toLowerCase()}s/${votableId}/unvote?vote_id=${vote.id}`,
                type: 'DELETE',
            })
        })

    })
}

function unvoteHandler(resourceSelector) {
    $(`${resourceSelector} .cancel-vote-link`).on('ajax:success', function(event) {
        const rating = event.detail[0].rating
        const votableId = event.detail[0].votable_id
        const votableName = event.detail[0].votable_name

        $(`#${votableName.toLowerCase()}-${votableId} .cancel-vote-link`).remove()
        $(`#${votableName.toLowerCase()}-${votableId} .vote-rating`).html(`Rating: ${rating}`)

        const voteField = $(`#${votableName.toLowerCase()}-${votableId} .${votableName.toLowerCase()}-vote`)

        let goodVoteButton = $('<button/>', { text: 'Good' })
        goodVoteButton.addClass('btn btn-outline-success vote-link')

        let br = document.createElement('br')

        let badVoteButton = $('<button/>', { text: 'Bad' })
        badVoteButton.addClass('btn btn-outline-danger vote-link')

        voteField.append(goodVoteButton, br, badVoteButton)

        voteField.find('button:contains("Good")').on('click', function(){
            $.ajax({
                url: `/${votableName.toLowerCase()}s/${votableId}/vote?votable=${votableName}&vote_state=good`,
                type: 'POST'
            })
        })

        voteField.find('button:contains("Bad")').on('click', function(){
            $.ajax({
                url: `/${votableName.toLowerCase()}s/${votableId}/vote?votable=${votableName}&vote_state=bad`,
                type: 'POST'
            })
        })
    })
}
