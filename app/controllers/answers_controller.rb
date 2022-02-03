class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answers = Answer.all
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully sent.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
