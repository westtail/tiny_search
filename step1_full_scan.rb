# Step 1: 全文スキャン
# すべての文書を毎回頭から読み、クエリ文字列を含むかどうかだけを見る。
require "json"

docs = JSON.parse(File.read(File.join(__dir__, "docs.json")))

def search(docs, query)
  q = query.downcase
  docs.select { |_id, doc| "#{doc["title"]} #{doc["body"]}".downcase.include?(q) }
end

query = ARGV[0] || "ruby"
hits = search(docs, query)

puts "query: #{query.inspect} -> #{hits.size} hits"
hits.each { |id, doc| puts "  [#{id}] #{doc["title"]}" }
