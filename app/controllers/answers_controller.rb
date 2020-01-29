class AnswersController < ApplicationController 
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :choose_the_best]

  after_action :publish_answer, only: [:create]

  include Voted

  authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    AnswerNotificationJob.perform_later(@answer) if @answer.persisted?
  end

  def update
    authorize! :update, @answer
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    authorize! :destroy, @answer
    @answer.destroy
  end

  def choose_the_best
    authorize! :choose_the_best, @answer
    @answer.choose_the_best
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question#{@answer.question.id}",
      answer: @answer,
      question_author_id: @answer.question.user.id
    )
  end
end
