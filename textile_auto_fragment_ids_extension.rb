# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class TextileAutoFragmentIdsExtension < Radiant::Extension
  version "1.0"
  description "Add random, autogenerated ids to common block level textile elements."
  url "http://github.com/tricycle/radiant-textile-auto-fragment-ids-extension"
  
  def activate
    PagePart
    require 'app/models/page_part_ext'
  end
  
end