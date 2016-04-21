class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_edit_right, only: [:edit, :update, :destroy]

  respond_to :html

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      NotificationMailer.send_new_comment(@comment)

      flash[:success] = 'Kommentar wurde erfolgreich erstellt.'
    else
      flash[:error] = 'Fehler beim Speichern des Kommentars.'
    end
    redirect_to @comment.track
  end

  def update
    @comment.update(comment_params)
    if @comment.save
      flash[:success] = 'Kommentar wurde erfolgreich geändert.'
    else
      flash[:error] = 'Fehler beim Speichern des Kommentars.'
    end
    respond_with(@comment.track)
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Kommentar wurde erfolgreich gelöscht.'
    respond_with(@comment.track)
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params[:comment].merge!(user_id: current_user.id) if current_user
      params.require(:comment).permit(:user_id, :track_id, :text)
    end

    def ensure_edit_right
      unless @comment.user_id == current_user.id || current_user.admin?
        redirect_to root_path, flash: { error: 'Aktion nicht erlaubt.' }
      end
    end
end
