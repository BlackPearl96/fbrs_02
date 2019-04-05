module ApplicationHelper
  def full_title page_title
    base_title = I18n.t("title")
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def select_roles
    User.roles.keys.map {|role| [role.titleize, role]}
  end

  def load_categories_for_selectbox
    @categories = Category.sort_by_name.map{|c| [c.name, c.id]}
  end

  def load_categories
    Category.sort_by_name
  end
end
