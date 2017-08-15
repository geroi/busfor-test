class RouteDecorator < SimpleDelegator
  class Weekday < SimpleDelegator
    def to_word
      I18n.t("date.day_names")[self]
    end
  end

  def weekdays_str
    return I18n.t("date.everyday") if everyday?
    weekdays.sort.map(&:to_word).map(&:capitalize).join(' ')
  end

  def everyday?
    ((0..6).to_a - weekdays.map(&:to_i)).empty?
  end

  def weekdays
    super.map { |wd| Weekday.new(wd) }
  end

  %w(arrival departure).each do |direction|
    define_method "#{direction}_time_str".to_sym do
      [sprintf("%02d",send("#{direction}_hours")),
       sprintf("%02d",send("#{direction}_minutes"))].join(":")
    end
  end
end
