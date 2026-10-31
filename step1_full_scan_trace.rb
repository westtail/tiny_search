# Step 1 (途中経過つき): step1_full_scan.rb と同じ処理に、各段階の中身を表示する行を足したもの
require "json"

# --- 1. 文書を読み込む ---
docs = JSON.parse(File.read(File.join(__dir__, "docs.json")))
puts "== 1. 読み込み"
puts "docs.class: #{docs.class} / 件数: #{docs.size}"
puts "最初の1件: #{docs.first.inspect}"
puts

def search(docs, query)
  # --- 2. クエリを小文字にする ---
  q = query.downcase
  puts "== 2. クエリ: #{query.inspect} -> #{q.inspect}"
  puts

  # --- 3. 文書を1件ずつ調べる ---
  puts "== 3. 全文書を順番にチェック"
  result = docs.select do |id, doc|
    text = "#{doc["title"]} #{doc["body"]}".downcase
    hit = text.include?(q)
    pos = text.index(q)
    found = pos ? text[[pos - 10, 0].max, q.size + 20] : "-"
    puts format("  [%2s] %-5s 位置:%-4s 周辺: %s", id, hit, pos || "-", found.inspect)
    hit
  end
  puts
  result
end

query = ARGV[0] || "ruby"
hits = search(docs, query)

# --- 4. 結果 ---
puts "== 4. 結果"
puts "hits.class: #{hits.class}"
puts "query: #{query.inspect} -> #{hits.size} hits"
hits.each { |id, doc| puts "  [#{id}] #{doc["title"]}" }
