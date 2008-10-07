module PagePartExt
  def self.included(base)
    base.class_eval do
      before_save :add_ids
    end
  end

  private

  def add_ids
    if filter.is_a?(TextileFilter) || (TextileFilter == filter)
      self.content = processed_textile
    end
  end

  def processed_textile
    return nil unless content
    content.gsub(/^(bq|p|h[1-6])(\(([^#)]+)\))?\.(?= +\S)/) do |match|
      "#$1(#{$3 ? "#$3 " : ""}##{random_id})."
    end
  end

  def random_id
    (1..4).collect { random_options.rand }.join
  end
  def random_options
    ["a".."k", "m".."t", "w".."z", ["0"], "2".."9"].collect(&:to_a).flatten
  end
end
