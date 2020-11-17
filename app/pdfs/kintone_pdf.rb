class KintonePdf < Prawn::Document
  include ApplicationHelper

  def initialize(post)
    super(page_size: 'A4', page_layout: :landscape) # 縦 = :portrait, 横 = :landscape
    @post = post

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

    # draw_text @post['record']['jp_date']['value'], size: 11, at: [530, 463]
    # draw_text @post['record']['jp_date']['value'], size: 11, at: [530, 463]

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
    draw_text "9240", size: 11, at: [40, 465]
    draw_text "秋田マッカラー(株)", size: 11, at: [130, 465]
    draw_text "2", size: 11, at: [270, 465]

    bounding_box([0, 450], width: 770, height: 445
    ) {
      # border_development

      table([
        [
          make_cell(width: 105, height: 15),
          make_cell(rowspan: 2, width: 15),
          make_cell(colspan: 3),
          make_cell(width: 204),
          make_cell(rowspan: 2, width: 15),
          make_cell(width: 32, rowspan: 2),
          make_cell(width: 32, rowspan: 2),
          make_cell(width: 65),
          make_cell(width: 80),
          make_cell(width: 100, rowspan: 2)],
        [
          make_cell(height: 25),
          make_cell(width: 45),
          make_cell(width: 60),
          make_cell(width: 15),
          make_cell(width: 204),
          make_cell(width: 65),
          make_cell(width: 80)
        ]
      ]){
        column(0..10).style align: :center
        # row(0..9).height = 10
        # row(0..9).height = 28
      }
    }    
  end

  def table_body
    draw_text "農協コード(上段)", size: 11, at: [13, 438]
    draw_text "``", size: 15, at: [20, 410]
    draw_text "名(下段)", size: 11, at: [57, 417]
    draw_text "名(下段)", size: 11, at: [57, 417]
    vertical_text '受・区', size: 9, at: [108, 438]
    draw_text "受注NO.", size: 11, at: [158, 438]
    draw_text "農協コード", size: 8, at: [123, 425]
    draw_text "上3桁", size: 8, at: [133, 413]
    draw_text "連 続", size: 10, at: [184, 425]
    draw_text "番 号", size: 10, at: [184, 413]
    draw_text "品名コード(上段)", size: 11, at: [300, 438]
    draw_text "品名.規格.型式(下段)", size: 11, at: [292, 418]
    vertical_text '要　区', size: 9, at: [447, 438]
    draw_text "納期", size: 11, at: [464, 425]
    draw_text "数量", size: 11, at: [496, 425]
    draw_text "供給単価", size: 11, at: [533, 438]
    draw_text "受入単価", size: 11, at: [605, 438]
    draw_text "(農協渡)", size: 11, at: [536, 418]
    draw_text "(全農渡)", size: 11, at: [606, 418]
    draw_text "備考", size: 11, at: [670, 424]

    if @post["record"]['table']['value'][0].present?
      record_id = 0
      row_1 = 378
      row_2 = 377
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 397]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][1].present?
      record_id = 1
      row_1 = 341
      row_2 = 340
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 360]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][2].present?
      record_id = 2
      row_1 = 304
      row_2 = 303
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 323]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][3].present?
      record_id = 3
      row_1 = 267
      row_2 = 266
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 286]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][4].present?
      record_id = 4
      row_1 = 230
      row_2 = 229
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 249]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][5].present?
      record_id = 5
      row_1 = 193
      row_2 = 192
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 212]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][6].present?
      record_id = 6
      row_1 = 156
      row_2 = 155
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 175]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][7].present?
      record_id = 7
      row_1 = 119
      row_2 = 118
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 138]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][8].present?
      record_id = 8
      row_1 = 82
      row_2 = 81
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 101]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][9].present?
      record_id = 9
      row_1 = 45
      row_2 = 44
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 64]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    if @post["record"]['table']['value'][10].present?
      record_id = 10
      row_1 = 8
      row_2 = 7
      column_1 = 670

      draw_text @post["record"]['table']['value'][record_id]['value']['ja_name']['value'], size: 7, at: [2, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][0], size: 12, at: [125, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][1], size: 12, at: [140, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][2], size: 12, at: [155, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][3], size: 12, at: [170, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][4], size: 12, at: [185, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][5], size: 12, at: [200, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['order_number']['value'][6], size: 12, at: [215, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['product_name']['value'], size: 9, at: [243, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['delivery_date']['value'], size: 9, at: [461, row_1]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-1], size: 10, at: [515, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-2], size: 10, at: [509, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['quantity']['value'][-3], size: 10, at: [503, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-1], size: 10, at: [572, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-2], size: 10, at: [566, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-3], size: 10, at: [560, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-4], size: 10, at: [551, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-5], size: 10, at: [545, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-6], size: 10, at: [539, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['ja_price']['value'][-7], size: 10, at: [532, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-1], size: 10, at: [652, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-2], size: 10, at: [646, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-3], size: 10, at: [640, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-4], size: 10, at: [631, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-5], size: 10, at: [625, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-6], size: 10, at: [619, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['z_price']['value'][-7], size: 10, at: [612, row_2]
      draw_text @post["record"]['table']['value'][record_id]['value']['list_price']['value'], size: 8, at: [column_1, 27]
      draw_text @post["record"]['table']['value'][record_id]['value']['note']['value'], size: 8, at: [column_1, row_1]
    end

    bounding_box([0, 410], width: 770, height: 800
    ) {
      table([
        # 1行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],
        
        # 2行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 3行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 4行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 5行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 6行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 7行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 8行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 9行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 10行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
        ],

        # 11行
        [
          make_cell(width: 15, height: 17),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 15),
          make_cell(width: 30, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),

          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(content: "2", size: 9, align: :right, width: 17, height: 20),
          make_cell(content: "1", size: 9, align: :right, width: 17, height: 20),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17),
          make_cell(width: 17, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          
          make_cell(width: 32, background_color: "cccccc"),
          make_cell(width: 32, background_color: "cccccc"),
          
          make_cell(width: 15, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 20, background_color: "cccccc"),
          make_cell(width: 30, background_color: "cccccc"),
          make_cell(width: 100, rowspan: 2)
        ],
        [
          make_cell(height: 17, colspan: 6),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          
          make_cell(height: 17, colspan: 12),
          
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17),
          make_cell(height: 17)
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
