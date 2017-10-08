# frozen_string_literal: true

class ReviewDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.strftime('%D')
  end

  def context
    object.context
  end

  def book_score
    stars = "<div class='mb-15'>" +
            "<i class='fa fa-star rate-star'></i>" * object.score +
            "<i class='fa fa-star rate-star rate-empty'></i>" * (5 - object.score) +
            '</div>'
    stars.html_safe
  end

  def user_avatar
    with_image = "<img class='img-circle logo-size inlide-block pull-left' src='#{object.user.image}'>".html_safe
    return with_image if object.user.image
    letter = object.user.email[0].upcase
    "<span class='img-circle logo-size inlide-block pull-left logo-empty'>#{letter}</span>".html_safe
  end

  def user_name
    try_any_name || 'No Name'
  end

  def status_name
    if object.status
      I18n.t('admin.review.approved')
    else
      object.status.nil? ? I18n.t('admin.review.unprocessed') : I18n.t('admin.review.rejected')
    end
  end

  def verified?
    OrderItem.where(
      book_id: object.book_id,
      order_id: object.user.orders.where_status(:delivered).ids
    ).any?
  end

  private

  def try_any_name
    return get_name(object.user) if object.user.last_name
    get_name(object.user.addresses.billing.first) unless object.user.addresses.empty?
  end

  def get_name(subject)
    subject.last_name[0].upcase + '. ' + subject.first_name.capitalize
  end
end
