class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answers = Answer.all
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.set_author(current_user)
    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully sent.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    answer = @answer.destroy if current_user.author_of? @answer
    redirect_to answer.question, notice: 'Your answer successfully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
