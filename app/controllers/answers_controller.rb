class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(author: current_user))
    if @answer.save
      respond_to do |format|
        format.js { flash.now[:notice] = 'Your answer successfully sent.' }
      end
    end
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      respond_to do |format|
        format.js { flash.now[:notice] = 'Your answer successfully deleted.' }
      end
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
