collection @traders
attributes :name, :short_name

node :currencies do |trader|
  trader.currencies.reduce({}) {
    |h, v| h.merge(Hash[v.note, partial('currencies/show', object: v)])
  }
end
