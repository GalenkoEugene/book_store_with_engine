ActiveAdmin.register Review do
  permit_params :list, :of, :attributes, :on, :model
  includes :book
  decorate_with ReviewDecorator

  scope :all { |reviews| reviews.all }
  scope :new, default: true do |reviews| reviews.where(status: nil) end
  scope :processed { |reviews| reviews.where.not(status: nil) }

  index do
    selectable_column
    column I18n.t('admin.review.title') do |review| review.book.title end
    column I18n.t('admin.review.date'), :created_at
    column I18n.t('admin.review.user') do |review| review.user.email end
    column I18n.t('admin.review.context'), :context
    column I18n.t('admin.review.status') do |review|
      status_tag(review.status_name)
    end
    column do |review|
      (link_to I18n.t('admin.review.approve'),
        approve_admin_review_path(review), method: :put) + ' - ' +
      (link_to I18n.t('admin.review.reject'),
        reject_admin_review_path(review), method: :put)
    end
  end

  member_action :approve, method: :put do
    review = Review.find(params[:id])
    review.approve!
    redirect_back(fallback_location: admin_reviews_path,
      notice: "#{I18n.t('admin.review.approved')}!")
  end

  member_action :reject, method: :put do
    review = Review.find(params[:id])
    review.reject!
    redirect_back(fallback_location: admin_reviews_path,
      danger: "#{I18n.t('admin.review.rejected')}!")
  end
end
