module ApplicationHelper

  YOHAKU = 2 #文字間隔調整の値
  # Options
  # at (required),  [x,y] The position at which to start the text
  # size
  # style
  # kerning boolean
  # center boolean automatically text start index with at
  # height New line when you exceed this value
  def vertical_text(text, options = {}) 
    letters = text.split(//) # 1文字分割して配列にする
    f_size = options[:size] || font_size # font_sizeはPrawn::Document内で定義されているメソッドです。
    options[:at] ||= [0, 0]
    origin_at = options[:at]

    # 自動改行
# height指定されていなければ改行しない。この高さを超えたら改行
    if options[:height] 
      height = options[:height].to_i
      letter_line_height = 0
      letters.each_with_index do |letter, i|
        letter_line_height = 0 and next if letter.breakcode?
        letter_line_height += f_size + YOHAKU
        if letter_line_height > height
          letters.insert(i, "\n")
          letter_line_height = 0
        end
      end
    end

    #改行して複数行になったときに自動で中央を調整するか
    if options[:center]
      line_count = calculate_line_count(letters)
      align_index = (f_size / 2) * (line_count -1)
      options[:at] = [options[:at][0] + align_index, options[:at][1]]
    end
    letters.each do |letter|
 # 改行コードの場合はx座標をずらして次へ
      if letter.breakcode?
        options[:at] = [options[:at][0] - f_size - YOHAKU, origin_at[1]]
        next
      end
# 長音符の場合は例外処理を行う-90度回転させる。ただ回転させるだけだとテキストのベースラインの関係から文字が重なるのでy座標を調整する
      if letter.macron? 
        options[:rotate] = -90
        options[:at] = [options[:at][0], options[:at][1] + f_size]
      else
        options[:rotate] = 0
      end
      draw_text(letter, options) # 文字の描画
      options[:at] = [options[:at][0], options[:at][1] - f_size] if letter.macron? #長音符の場合は例外処理したy座標を元に戻す
      options[:at] = [options[:at][0], options[:at][1] - f_size - YOHAKU] #y座標をフォントサイズ+余白分ずらす
    end
  end

  private
  # 行数を数えるメソッド
  # Args
  # arry: 1文字ごとの配列
  def calculate_line_count(arry)
    line_count = arry.count("\n")
    line_count = arry.count("\r") if line_count == 0
    line_count = arry.count("\r\n") if line_count == 0
    line_count += 1
    return line_count
  end 
end
