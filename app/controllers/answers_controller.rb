class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(author: current_user))
    if @answer.save
      respond_to do |format|
        format.js { flash.now[:notice] = 'Your answer successfully sent.' }
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      respond_to do |format|
        format.js { flash.now[:notice] = 'Your answer successfully deleted.' }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
