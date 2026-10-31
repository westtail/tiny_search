# Step 2: トークナイズ
# テキストを単語(トークン)の配列に分け、文字列の部分一致ではなく単語単位で一致を判定する。
# 複数語のクエリは、すべての語を含む文書だけを返す(AND検索)。
require "json"

docs = JSON.parse(File.read(File.join(__dir__, "docs.json")))

# 小文字化して、英数字のまとまりを1単語として取り出す
# "TF-IDF gives..." -> ["tf", "idf", "gives", ...]
def tokenize(text)
  text.downcase.scan(/[a-z0-9]+/)
end

def search(docs, query)
  terms = tokenize(query)
  return {} if terms.empty?

  docs.select do |_id, doc|
    tokens = tokenize("#{doc["title"]} #{doc["body"]}")
    terms.all? { |t| tokens.include?(t) } # AND: すべての語を含む
  end
end

query = ARGV[0] || "ruby"
hits = search(docs, query)

puts "query: #{query.inspect} -> terms: #{tokenize(query).inspect} -> #{hits.size} hits"
hits.each { |id, doc| puts "  [#{id}] #{doc["title"]}" }
