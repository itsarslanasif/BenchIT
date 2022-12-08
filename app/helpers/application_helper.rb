module ApplicationHelper
  # rubocop:disable Rails/OutputSafety
  def ui_translations(section)
    translations = { current: I18n.t('.')[:vue][section] }
    translations.to_json.html_safe
  end
  # rubocop:enable Rails/OutputSafety

  def paginate(scope, default_per_page = scope.default_per_page)
    collection = scope.page(params[:page]).per((params[:per_page] || default_per_page).to_i)
    current = collection.current_page
    total = collection.total_pages
    per_page = collection.limit_value

    {
      current: current,
      previous: (current > 1 ? (current - 1) : nil),
      next: (current == total ? nil : (current + 1)),
      per_page: per_page,
      pages: total,
      count: collection.total_count
    }
  end
end
