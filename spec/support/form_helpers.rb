# frozen_string_literal: true

module FormHelpers
  def submit_form
    find('input[type="submit"]').click
  end
end
