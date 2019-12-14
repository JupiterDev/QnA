class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    if @answer.persisted?
      flash.now[:notice] = 'Your answer has been successfully created.'
    else
      flash.now[:alert] = 'Your answer has not been created.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to question_path(@answer.question)
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
