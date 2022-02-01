class AnswersController < ApplicationController
  expose :answers, -> { Answer.all }
  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer, parent: :question

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
