module ApplicationHelper
  def full_title page_title
    base_title = t ".tab_describer"
    page_title.present? ? [page_title, base_title].join(" | ") : base_title
  end
end
