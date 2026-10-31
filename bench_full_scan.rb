# 全文スキャン(ステップ1)とトークナイズ(ステップ2)の検索が、
# 文書の「数」と「長さ」でどのくらい遅くなるかを計測する。
# 文書は docs.json に出てくる単語をランダムに並べて作る(ネット不要、毎回同じ結果になるよう乱数を固定)。
require "json"
require "benchmark"

base = JSON.parse(File.read(File.join(__dir__, "docs.json")))
VOCAB = base.values.flat_map { |d| "#{d["title"]} #{d["body"]}".downcase.scan(/[a-z0-9]+/) }.uniq
QUERIES = %w[ruby index search bm25 japanese] # 平均をとるための検索語
RNG = Random.new(42)

# n件の文書を、1件あたり words 語で作る
def make_docs(n, words)
  (1..n).to_h { |i| [i.to_s, { "title" => "doc #{i}", "body" => Array.new(words) { VOCAB.sample(random: RNG) }.join(" ") }] }
end

# ステップ1と同じ検索
def search_step1(docs, query)
  q = query.downcase
  docs.select { |_id, doc| "#{doc["title"]} #{doc["body"]}".downcase.include?(q) }
end

# ステップ2と同じ検索
def tokenize(text) = text.downcase.scan(/[a-z0-9]+/)
def search_step2(docs, query)
  terms = tokenize(query)
  docs.select { |_id, doc| tokens = tokenize("#{doc["title"]} #{doc["body"]}"); terms.all? { |t| tokens.include?(t) } }
end

# 検索語ごとに1回ずつ検索し、1回あたりの平均ミリ秒を返す
def measure(docs, method)
  total = QUERIES.sum { |q| Benchmark.realtime { send(method, docs, q) } }
  total / QUERIES.size * 1000
end

def row(label, docs)
  s1 = measure(docs, :search_step1)
  s2 = measure(docs, :search_step2)
  puts format("| %-14s | %10.2f ms | %10.2f ms |", label, s1, s2)
end

puts "語彙数: #{VOCAB.size}語 / 検索語: #{QUERIES.join(", ")} の平均"
puts
puts "## A. 文書の数を増やす(1件30語で固定)"
puts "| 文書数         | ステップ1     | ステップ2     |"
puts "|----------------|---------------|---------------|"
[1_000, 10_000, 100_000].each { |n| row("#{n}件", make_docs(n, 30)) }
puts
puts "## B. 文書の長さを増やす(1,000件で固定)"
puts "| 1件の長さ      | ステップ1     | ステップ2     |"
puts "|----------------|---------------|---------------|"
[10, 100, 1_000, 10_000].each { |w| row("#{w}語", make_docs(1_000, w)) }
