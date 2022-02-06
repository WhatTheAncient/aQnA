document.addEventListener('turbolinks:load', function() {
  const controls = document.querySelectorAll('.answers')
  if (controls)
    controls.forEach((element) => element.addEventListener('click', formInlineLinkHandler))

  const errors = document.querySelector('.resource-errors')
  if (errors) {
    const resourceId = errors.dataset.resourceId
    formInlineHandler(resourceId)
  }
})

function formInlineLinkHandler(event) {
  const editLink = this.querySelector('.edit-answer-link')
  if (event.target === editLink) {
    event.preventDefault()

    const answerId = editLink.dataset.answerId
    formInlineHandler(answerId)
  }
}

function formInlineHandler(answerId) {
  const link = document.querySelector(`.edit-answer-link[data-answer-id="${answerId}"]`)
  const answer = document.getElementById(`${answerId}`)
  const formInline = document.querySelector(`.inline-form[data-answer-id="${testId}"]`)

  if (formInline.classList.contains('hide')) {
    answer.querySelector('.answer-body').classList.add('hide')
    formInline.classList.remove('hide')
    link.textContent = 'Cancel'
  } else {
    answer.querySelector('.answer-body').classList.remove('hide')
    formInline.classList.add('hide')
    link.textContent = 'Edit'
  }
}
