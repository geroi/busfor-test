require 'rails_helper'

RSpec.describe LoadInitialData do
  let(:yaml) do
    <<~YML
    ---
    - :start_city_name: Киев
      :station_begin_name: 'Автостанция "Киев" '
      :start_date: 15.05.2017
      :start_time: '01:00'
      :end_city_name: Львов
      :station_end_name: г. Львов, автостанция № 8
      :end_date: 15.05.2017
      :end_time: '09:00'
      :carrier_name: '"Павлюк Виталий Иванович" ФЛП'
      :total_cost: '687.93'
      :currency: RUB
    YML
  end

  let(:file_name) do
    file = Tempfile.new
    file.write(yaml)
    file.close
    file.path
  end

  let(:result) { described_class.call(files: [file_name]) }

  it "should successfully exit" do
    expect(result.success?).to be_truthy
  end

  it "should load route log" do
    expect { result}.to change { RouteLog.count }.by 1
  end
end
