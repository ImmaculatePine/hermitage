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

# Workaround for clicking exactly on the specified position of the element
def click_at(selector, offset_x, offset_y)
  x = left(selector) + width(selector) * offset_x
  y = top(selector) + height(selector) * offset_y
  page.driver.click(x, y)
end

def click_at_left(selector)
  click_at(selector, 0.25, 0.5)
end

def click_at_right(selector)
  click_at(selector, 0.75, 0.5)
end

def jquery_text(selector)
  evaluate_script("$('#{selector}').text()")
end