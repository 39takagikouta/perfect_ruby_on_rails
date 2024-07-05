require 'csv'
require 'time'
data2 = []

data = CSV.read("sample_log.csv")

data.each do |row|
  # 実装1 2020年1月1日0時0分以前に入会している
  if Time.parse(row[3]) <= Time.parse("2020-01-01 00:00:00")
    data2 << row[0]
  end
end

data3 = []

data.each do |arr|
  data2.each do |arr2|
    if arr[0] == arr2
      data3 << arr
    end
  end
end

data3.uniq!

# 実装2 2020年4月1日0時0分までやめていない（やめているものを見つけて削除）
data3.each_cons(2).each_with_index do |(a,b),index|
  if a[0] == b[0] && a[1] == a[1] && b[2] == "0" && Time.parse(b[3]) <= Time.parse("2020-04-01 00:00:00")#同じユーザーで同じクラスで4月1日以前に退会の処理である
    # 実装3 同月に再開していれば残す（やめたデータ移行の配列で、再開したものがあれば残す）
    unless data3[index..-1].any? {|arr| arr[0] == b[0] && arr[1] == b[1] && arr[2] == "1" && Time.parse(arr[3]).month == Time.parse(b[3]).month } #同じユーザーで同じクラスで4月1日以前に再入会の処理である
      data3.delete_if {|arr| arr.include?(b[0])}
    end
  end
end

# データの加工・出力
ids = data3.map {|a| a[0].to_i}.uniq
ids.sort!
ids.each {|a| puts a}
