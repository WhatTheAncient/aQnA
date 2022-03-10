class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  before_action :find_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy

  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: [:name, :url],
                                     reward_attributes: [:name, :image])
  end
end
