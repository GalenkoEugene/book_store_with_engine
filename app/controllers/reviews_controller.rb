class ReviewsController < ApplicationController
  load_and_authorize_resource

  def create
    @review = Review.new(review_params)
    @review.save ? flash[:success] = t('review.thanks_message') : flash[:danger] = t('review.smth_went_wrong')
    redirect_back(fallback_location: root_path)
  end

  private

  def review_params
    params.require(:review).permit(:book_id, :user_id, :score, :context)
  end
end
