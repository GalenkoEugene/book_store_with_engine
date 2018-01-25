ActiveAdmin.register Cartify::Order, as: 'Order' do
  includes :coupon, :order_status
  permit_params :order_status_id
  filter :order_status
  decorate_with Cartify::OrderDecorator

  scope :in_progress, default: true do |tasks|
    tasks.processing_list
  end

  scope :delivered do |tasks|
    tasks.where_status(:delivered)
  end

  scope :canceled do |tasks|
    tasks.where_status(:canceled)
  end

  index do
    column(I18n.t('admin.order.number')) { |order| order.number }
    column(I18n.t('admin.order.created_at')) { |order| order.creation_date }
    column(I18n.t('admin.order.state')) { |order| order.status }
    column do |order|
      link_to I18n.t('admin.order.change_state'), edit_admin_order_path(order)
    end
  end

  form title: I18n.t('admin.order.can_change_state'), decorate: true do |f|
    inputs t('admin.order.details') do
      input :order_status, as: :select,
        collection: Cartify::OrderStatus.pluck(:name, :id), include_blank: false
      h3 li "#{t('admin.order.current')}: #{f.order.status}" unless f.order.new_record?
    end
    actions
    panel I18n.t('admin.order.rules') do
      h2 I18n.t('admin.order.rules_context')
    end
  end

  controller do
    def update
      action = -> { redirect_to edit_admin_order_path(params[:id]),
        notice: I18n.t('admin.order.success')
      }
      super { action.call and return } if valid_transition?
      redirect_to edit_admin_order_path(params[:id]),
        danger: I18n.t('admin.order.error')
    end

    private

    def valid_transition?
      Cartify::Order.find(params[:id]).order_status.valid_step?(params[:order][:order_status_id])
    end
  end
end
