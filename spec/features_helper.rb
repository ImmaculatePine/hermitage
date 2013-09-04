#
# There are helper methods for features specs
#

def css(selector, css)
  evaluate_script("$('#{selector}').css('#{css}')")
end

def width(selector)
  evaluate_script("$('#{selector}').outerWidth()")
end

def height(selector)
  evaluate_script("$('#{selector}').outerHeight()")
end

def top(selector)
  evaluate_script("$('#{selector}').position().top")
end

def left(selector)
  evaluate_script("$('#{selector}').position().left")
end