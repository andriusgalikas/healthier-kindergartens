module Admin::MessageHelper

  def pretty_sent_date(date)
    date.strftime('%d/%m/%Y') + ' @ ' + date.strftime('%r')
  end

end
