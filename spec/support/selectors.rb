# frozen_string_literal: true

include Rails.application.routes.url_helpers

module Selectors
  Capybara.add_selector(:linkhref) do
    xpath {|href| ".//a[@href='#{href}']"}
  end

  Capybara.add_selector(:filter_by_category) do
    xpath {|cat_id| ".//a[@href='#{catalog_path(category: cat_id)}']"}
  end

  Capybara.add_selector(:log_out) do
    xpath {".//div[@class='hidden-xs']//a[@href='/users/sign_out']"}
  end
end
