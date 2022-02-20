class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(author: current_user))
    flash.now[:notice] = 'Your answer successfully sent.' if @answer.save
    #  AjaJSON code
    #  respond_to do |format|
    #   if @answer.save
    #      format.json { render json: @answer }
    #   else
    #     format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
    #   end
    #  end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer successfully deleted.'
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
