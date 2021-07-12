class NewKintonePdf < Prawn::Document
  include ApplicationHelper

  def initialize(new_post)
    super(page_size: 'A4', page_layout: :landscape) # 縦 = :portrait, 横 = :landscape
    @post = new_post

    font_families.update('jp_font' => { normal: 'vendor/fonts/ipaexm.ttf', bold: 'vendor/fonts/ipaexg.ttf' }) # 日本語フォント
    font 'jp_font', style: :bold
    
    header
    table_header
    table_body
    # development
  end

  def header
    draw_text "農業機械　受注一覧表", size: 17, at: [300, 520]
    draw_text "JA全農あきた", size: 15, at: [260, 500]
    draw_text "農業機械課　御中", size: 15, at: [405, 500]
    
    date = @post['record']['jp_date']['value']
    if date.length <= 11
      draw_text date, size: 11, at: [550, 463]
    elsif date.length <= 12
      draw_text date, size: 11, at: [543, 463]
    elsif date.length <= 13
      draw_text date, size: 11, at: [536, 463]
    else
      draw_text date, size: 11, at: [529, 463]
    end

    bounding_box([640, 477], width: 90, height: 20) {
      # border_development

      table([
        [make_cell(content: "No.  #{@post['record']['number']['value']}", size: 10)]
      ]){
        row(0).height = 19
        column(0).width = 70
      }
    }

    bounding_box([0, 495], width: 700, height: 40) {
      # border_development
      
      table([
        [
          make_cell(width: 105, height: 15),
          make_cell(width: 150),
          make_cell(width: 35)
        ],

        [
          make_cell(height: 20),
          make_cell(height: 20),
          make_cell(height: 20),
        ]
      ]){
        # ここでもCSS指定可能
        # column(0..2).size = 10
        # row(0).height = 10
        # column(0).width = 10
        # column(0).style align: :center
      }
    }

    # 判子
    if @post["record"]['user']['value'].present?
      name = @post["record"]['user']['value']

      if name.length  <= 0
        nil
      elsif name.length  <= 1
        vertical_text name, size: 27, at: [727, 460]
        stroke_circle [740,470], 15
      elsif name.length <= 2
        vertical_text name, size: 13, at: [734, 473]
        stroke_circle [740,470], 15
      elsif name.length <= 3
        vertical_text name, size: 8.5, at: [736, 477]
        stroke_circle [740,470], 15
      else
        draw_text name, size: 8.5, at: [715, 465]
      end
    end
  end

  def table_header
    draw_text "出荷先コード", size: 11, at: [20, 482]
    draw_text "出 荷 先 名", size: 11, at: [150, 482]
    draw_text "区分", size: 11, at: [262, 482]
    draw_text @post["record"]['shipping_code']['value'], size: 11, at: [40, 465]
    draw_text @post["record"]['company_name']['value'], size: 11, at: [120, 465]
    draw_text @post["record"]['classification']['value'], size: 11, at: [270, 465]

    bounding_box([0, 450], width: 770, height: 445
    ) {
      # border_development

      table([
        [
          make_cell(width: 105, rowspan: 2, height: 40),
          make_cell(width: 135, rowspan: 2),
          make_cell(width: 219, rowspan: 2),
          make_cell(width: 32, rowspan: 2),
          make_cell(width: 32, rowspan: 2),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100, rowspan: 2)
          # make_cell(width: 80),
          # make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 20),
          make_cell(height: 20)
          # make_cell(width: 60),
          # make_cell(width: 15),
          # make_cell(width: 204),
          # make_cell(width: 65),
          # make_cell(width: 80)
        ]
      ]){
        column(0..10).style align: :center
        # row(0..9).height = 10
        # row(0..9).height = 28
      }
    }    
  end

  def table_body
    draw_text "ＪＡ名", size: 11, at: [30, 425]
    # draw_text "``", size: 15, at: [20, 410]
    # draw_text "名(下段)", size: 11, at: [57, 417]
    # draw_text "名(下段)", size: 11, at: [57, 417]
    # vertical_text '受・区', size: 9, at: [108, 438]
    draw_text "受注NO.", size: 11, at: [150, 425]
    # draw_text "農協コード", size: 8, at: [123, 425]
    # draw_text "上3桁", size: 8, at: [133, 413]
    # draw_text "連 続", size: 10, at: [184, 425]
    # draw_text "番 号", size: 10, at: [184, 413]
    draw_text "型式・品名", size: 11, at: [325, 425]
    # draw_text "品名.規格.型式(下段)", size: 11, at: [292, 418]
    # vertical_text '要　区', size: 9, at: [447, 438]
    draw_text "納期", size: 11, at: [464, 425]
    draw_text "数量", size: 11, at: [496, 425]
    draw_text "供給単価", size: 11, at: [533, 438]
    draw_text "受入単価", size: 11, at: [605, 438]
    draw_text "(農協渡)", size: 11, at: [536, 418]
    draw_text "(全農渡)", size: 11, at: [606, 418]
    draw_text "備考", size: 11, at: [705, 425]

    note_size = 6
    order_number_size = 11
    product_name_size = 11
    ja_price_size = 11
    z_price_size = 11
    quantity_size = 11

    # 1行目

    if @post["record"]['table']['value'][0].present?
      record_id = 0
      column_1 = 670

      bounding_box([0, 410], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 410], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(0))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 410], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 410], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 410], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 410], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 410], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 402]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 395]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 388]
      draw_text "農協(当用)#{normal_ja_price(0).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 381] unless normal_ja_price(0).blank?
      draw_text "全農(当用)#{normal_ja_price(0).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 374] unless normal_ja_price(0).blank?
    end

    # 2行目

    if @post["record"]['table']['value'][1].present?
      record_id = 1
      column_1 = 670

      bounding_box([0, 372], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 372], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(1))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 372], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 372], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 372], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 372], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 372], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 364]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 357]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 350]
      draw_text "農協(当用)#{normal_ja_price(1).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 343] unless normal_ja_price(1).blank?
      draw_text "全農(当用)#{normal_ja_price(1).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 336] unless normal_ja_price(1).blank?
    end

    # 3行目

    if @post["record"]['table']['value'][2].present?
      record_id = 2
      column_1 = 670

      bounding_box([0, 334], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 334], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(2))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 334], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 334], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 334], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 334], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 334], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 326]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 319]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 312]
      draw_text "農協(当用)#{normal_ja_price(2).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 305] unless normal_ja_price(2).blank?
      draw_text "全農(当用)#{normal_ja_price(2).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 298] unless normal_ja_price(2).blank?
    end

    # 4行目
    if @post["record"]['table']['value'][3].present?
      record_id = 3
      column_1 = 670

      bounding_box([0, 296], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 296], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(3))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 296], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 296], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 296], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 296], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 296], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 288]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 281]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 274]
      draw_text "農協(当用)#{normal_ja_price(3).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 267] unless normal_ja_price(3).blank?
      draw_text "全農(当用)#{normal_ja_price(3).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 260] unless normal_ja_price(3).blank?
    end

    # 5行目
    if @post["record"]['table']['value'][4].present?
      record_id = 4
      column_1 = 670

      bounding_box([0, 258], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 258], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(4))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 258], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 258], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 258], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 258], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 258], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 250]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 243]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 236]
      draw_text "農協(当用)#{normal_ja_price(4).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 229] unless normal_ja_price(4).blank?
      draw_text "全農(当用)#{normal_ja_price(4).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 222] unless normal_ja_price(4).blank?
    end

    # 6行目
    if @post["record"]['table']['value'][5].present?
      record_id = 5
      column_1 = 670

      bounding_box([0, 220], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 220], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(5))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 220], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 220], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 220], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 220], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 220], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 212]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 205]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 198]
      draw_text "農協(当用)#{normal_ja_price(5).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 191] unless normal_ja_price(5).blank?
      draw_text "全農(当用)#{normal_ja_price(5).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 184] unless normal_ja_price(5).blank?
    end

    # 7行目
    if @post["record"]['table']['value'][6].present?
      record_id = 6
      column_1 = 670

      bounding_box([0, 182], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 182], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(6))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 182], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 182], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 182], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 182], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 182], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 174]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 167]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 160]
      draw_text "農協(当用)#{normal_ja_price(6).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 153] unless normal_ja_price(6).blank?
      draw_text "全農(当用)#{normal_ja_price(6).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 146] unless normal_ja_price(6).blank?
    end

    # 8行目
    if @post["record"]['table']['value'][7].present?
      record_id = 7
      column_1 = 670

      bounding_box([0, 144], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 144], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(7))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 144], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 144], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 144], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 144], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 144], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 136]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 129]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 122]
      draw_text "農協(当用)#{normal_ja_price(7).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 115] unless normal_ja_price(7).blank?
      draw_text "全農(当用)#{normal_ja_price(7).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 108] unless normal_ja_price(7).blank?
    end

    # 9行目
    if @post["record"]['table']['value'][8].present?
      record_id = 8
      column_1 = 670

      bounding_box([0, 106], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 106], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(8))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 106], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 106], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 106], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 106], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 106], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 98]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 91]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 84]
      draw_text "農協(当用)#{normal_ja_price(8).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 77] unless normal_ja_price(8).blank?
      draw_text "全農(当用)#{normal_ja_price(8).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 70] unless normal_ja_price(8).blank?
    end

    # 10行目
    if @post["record"]['table']['value'][9].present?
      record_id = 9
      column_1 = 670

      bounding_box([0, 68], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 68], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(9))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 68], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 68], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 68], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 68], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 68], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 60]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 53]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 46]
      draw_text "農協(当用)#{normal_ja_price(9).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 39] unless normal_ja_price(9).blank?
      draw_text "全農(当用)#{normal_ja_price(9).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 32] unless normal_ja_price(9).blank?
    end

    # 11行目
    if @post["record"]['table']['value'][10].present?
      record_id = 10
      column_1 = 670

      bounding_box([0, 30], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['abbreviation']['value'])
            ]
          ]) {
            column(0).size = 9
            column(0).width = 105
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([240, 30], width: 230, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: product_name(10))
            ]
          ]) {
            column(0).size = product_name_size
            column(0).width = 219
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }
        
      bounding_box([105, 30], width: 150, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['order_number']['value'])
            ]
          ]) {
            column(0).size = order_number_size
            column(0).width = 135
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([459, 30], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'])
            ]
          ]) {
            column(0).size = 7
            column(0).width = 32
            column(0).height = 38
            column(0).align = :center
            column(0).valign = :center
          }
        }

      bounding_box([491, 30], width: 40, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['quantity']['value'])
            ]
          ]) {
            column(0).size = quantity_size
            column(0).width = 32
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      

      bounding_box([523, 30], width: 70, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['ja_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = ja_price_size
            column(0).width = 65
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }
      
      bounding_box([588, 30], width: 90, height: 40
        ) {
          # border_development
          table([
            [
              make_cell(content: @post["record"]['table']['value'][record_id]['value']['z_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'))
            ]
          ]) {
            column(0).size = z_price_size
            column(0).width = 80
            column(0).height = 38
            column(0).align = :right
            column(0).valign = :center
          }
        }

      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'].to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,'), size: note_size, at: [column_1, 22]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: note_size, at: [column_1, 15]
      draw_text @post["record"]['table']['value'][record_id]['value']['serial_number']['value'], size: note_size, at: [column_1, 8]
      draw_text "農協(当用)#{normal_ja_price(10).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, 1] unless normal_ja_price(10).blank?
      draw_text "全農(当用)#{normal_ja_price(10).to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')}", size: note_size, at: [column_1, -6] unless normal_ja_price(10).blank?
    end

    bounding_box([0, 410], width: 770, height: 800
    ) {
      table([
        # 1行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],
        
        # 2行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 3行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 4行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 5行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 6行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 7行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 8行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 9行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 10行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ],

        # 11行
        [
          make_cell(width: 105, height: 38),
          make_cell(width: 135),
          make_cell(width: 219),
          make_cell(width: 32),
          make_cell(width: 32),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100)
        ]
      ])
    }
  end

  def development
    if Rails.env.development?
      stroke_axis # 目盛りの表示
      stroke_circle [0,0], 10 # 原点

      stroke_color "ff0000"
      dash 3 # 点線
      stroke_vertical_line 0, 540, at: -35
      stroke_vertical_line 0, 540, at: 70
      stroke_vertical_line 0, 540, at: 175
      stroke_vertical_line 0, 540, at: 280
      stroke_vertical_line 0, 540, at: 385 # 真ん中
      stroke_vertical_line 0, 540, at: 490
      stroke_vertical_line 0, 540, at: 595
      stroke_vertical_line 0, 540, at: 700
      stroke_vertical_line 0, 540, at: 805

      stroke_horizontal_line 0, 770, at: -35
      stroke_horizontal_line 0, 770, at: 38.75
      stroke_horizontal_line 0, 770, at: 112.5
      stroke_horizontal_line 0, 770, at: 186.25
      stroke_horizontal_line 0, 770, at: 260 # 真ん中
      stroke_horizontal_line 0, 770, at: 333.75
      stroke_horizontal_line 0, 770, at: 407.5
      stroke_horizontal_line 0, 770, at: 481.25
      stroke_horizontal_line 0, 770, at: 555
    end
  end

  def border_development
    if Rails.env.development?
      stroke_color "0000ff"
      dash 1
      stroke_bounds
    end
  end
end
