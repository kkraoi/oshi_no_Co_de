class Admin::PostOptionsController < Admin::BaseController
  def index
    @languages = Language.all
    @new_language = Language.new(color: "none")
  end

  def create_language_option
    @new_language = Language.new(language_params)

    if @new_language.save
      redirect_to "#{admin_post_options_path}#languages", notice: '言語を追加しました'
    else
      @languages = Language.all
      flash.now[:alert] = "言語の追加に失敗しました"
      # status: :unprocessable_entity => バリデーション失敗422を伝える
      render :index, status: :unprocessable_entity
    end
  end

  def destroy_language_option
    language = Language.find(params[:id])
    language.destroy
    redirect_to "#{admin_post_options_path}#languages", notice: '言語の削除に成功しました'
  end

  private

  def language_params
    params.require(:language).permit(
      :name,
      :extension,
      :color
    )
  end
end
