class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update choose_best_answer destroy]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer)
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def choose_best_answer
    @answer = Answer.find(params[:answer_id])
    @question.set_best_answer(@answer) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:name, :url], reward_attributes: [:name, :image])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    unless @question.errors.any?

      rendered_question = ApplicationController.render(
        partial: 'questions/question_for_broadcast',
        locals: { question: @question }
      )

      ActionCable.server.broadcast(
        'questions',
        { question: rendered_question, question_id: @question.id }
      )
    end
  end
end
