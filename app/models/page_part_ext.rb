class PagePart
  before_save :add_ids

  private

  def add_ids
debugger
    if filter.is_a?(TextileFilter) || (TextileFilter == filter)
      self.content = processed_textile
    end
  end

  def processed_textile
    return nil unless content
    content.gsub(/^(bq|p|h[1-6])(\(([^#)]+)\))?\.(?= .)/) do |match|
      "#$1(#{$3 ? "#$3 " : ""}##{random_id})."
    end
  end

  def random_id
    (1..4).collect { (("A".."Z").to_a + ("0".."9").to_a)[rand(36)] }.join
  end
end
