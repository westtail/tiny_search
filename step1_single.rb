# Step 1 を「1文 × 1検索ワード」で確認する版
# 使い方: ruby step1_single.rb "検索ワード" "文章"(省略すると例文を使う)

query = ARGV[0] || "index"
text  = ARGV[1] || "You can learn tokenizing, indexing and scoring by writing the code yourself."

puts "== 1. 入力"
puts "文章:   #{text.inspect}"
puts "検索語: #{query.inspect}"
puts

puts "== 2. 小文字にする"
t = text.downcase
q = query.downcase
puts "文章:   #{t.inspect}"
puts "検索語: #{q.inspect}"
puts

puts "== 3. 文章の中に検索語の文字列があるか (include?)"
hit = t.include?(q)
puts "結果: #{hit}"
puts

puts "== 4. どこで見つかったか (index)"
pos = t.index(q)
if pos
  puts "位置: #{pos}文字目(0から数える)"
  puts t
  puts " " * pos + "^" * q.size
else
  puts "見つからない"
end
