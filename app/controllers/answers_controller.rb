class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy]
  after_action :publish_answer, only: %i[create]

  authorize_resource

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
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = 'Your answer successfully deleted.'
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    unless @answer.errors.any?
      rendered_answer = ApplicationController.render(
        partial: 'answers/answer_for_broadcast',
        locals: { answer: @answer }
      )

      ActionCable.server
                 .broadcast("question-#{@question.id}",
                            {
                              answer: rendered_answer,
                              answer_id: @answer.id,
                              answer_author_id: @answer.author.id,
                              question_author_id: @question.author.id
                            })
    end
  end
end
