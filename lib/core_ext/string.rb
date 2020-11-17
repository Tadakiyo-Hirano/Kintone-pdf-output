class String

  # 改行コードか
  def breakcode? 
    self == "\n" || self == "\r" || self == "\r\n"
  end
  
  # 長音符(ー)か
  def macron?
    self == "ー"
  end
end