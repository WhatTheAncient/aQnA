class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: %i[show update destroy]
  before_action :find_question, only: %i[index create]

  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswerListSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: @answer
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
