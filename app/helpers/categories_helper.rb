module CategoriesHelper
  def assigs(category, discussion_id)
    discussion = Discussion.find(discussion_id)
    if discussion.category == category
#    category = Category.find(category_id.id)
#    discussion = category.discussions.find(Discussion.find(discussion_id))
    #discussion = Discussion.find(discussion_id)
      return true
    else 
      return false
    end
  end
end
