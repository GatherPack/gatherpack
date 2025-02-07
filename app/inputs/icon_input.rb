class IconInput < SuperPickerInput
  def class_name
    "icon"
  end

  def classes
    "#{class_name}-select-wrapper form-control"
  end

  def wrapper_prefix
    "<i class='fa-solid fa-circle-question main-icon'></i>"
  end
end