unless Rails.env.production?

  def r
    reload!
  end

end